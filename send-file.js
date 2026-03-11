#!/usr/bin/env node
/**
 * 飞书文件发送工具
 * 绕过云盘,直接通过 IM API 发送文件
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const FormData = require('form-data');

// ========== 配置 ==========
// 从 OpenClaw 配置中读取
const CONFIG_PATH = '/root/.openclaw/config.yml';
let FEISHU_CONFIG = null;

function loadConfig() {
  try {
    const yaml = require('js-yaml');
    const configContent = fs.readFileSync(CONFIG_PATH, 'utf8');
    const config = yaml.load(configContent);
    
    // 假设飞书配置在 channels.feishu 下
    if (config.channels && config.channels.feishu && config.channels.feishu.accounts) {
      const defaultAccount = config.channels.feishu.accounts.default;
      if (defaultAccount) {
        FEISHU_CONFIG = {
          appId: defaultAccount.appId,
          appSecret: defaultAccount.appSecret,
        };
        return true;
      }
    }
    console.error('❌ 未找到飞书配置');
    return false;
  } catch (err) {
    console.error('❌ 读取配置失败:', err.message);
    return false;
  }
}

// ========== Step 1: 获取 tenant_access_token ==========
async function getTenantAccessToken() {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({
      app_id: FEISHU_CONFIG.appId,
      app_secret: FEISHU_CONFIG.appSecret,
    });

    const options = {
      hostname: 'open.feishu.cn',
      port: 443,
      path: '/open-apis/auth/v3/tenant_access_token/internal',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        try {
          const result = JSON.parse(data);
          if (result.code === 0) {
            resolve(result.tenant_access_token);
          } else {
            reject(new Error(`获取 token 失败: ${result.msg}`));
          }
        } catch (err) {
          reject(err);
        }
      });
    });

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

// ========== Step 2: 上传文件到临时素材库 ==========
async function uploadFile(token, filePath) {
  return new Promise((resolve, reject) => {
    if (!fs.existsSync(filePath)) {
      return reject(new Error(`文件不存在: ${filePath}`));
    }

    const form = new FormData();
    form.append('file_type', 'stream'); // 或 'pdf', 'doc' 等
    form.append('file_name', path.basename(filePath));
    form.append('file', fs.createReadStream(filePath));

    const options = {
      hostname: 'open.feishu.cn',
      port: 443,
      path: '/open-apis/im/v1/files',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        ...form.getHeaders(),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        try {
          const result = JSON.parse(data);
          if (result.code === 0) {
            resolve(result.data.file_key);
          } else {
            reject(new Error(`上传文件失败: ${result.msg}`));
          }
        } catch (err) {
          reject(err);
        }
      });
    });

    req.on('error', reject);
    form.pipe(req);
  });
}

// ========== Step 3: 发送文件消息 ==========
async function sendFileMessage(token, fileKey, receiveId) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify({
      receive_id: receiveId,
      msg_type: 'file',
      content: JSON.stringify({
        file_key: fileKey,
      }),
    });

    const options = {
      hostname: 'open.feishu.cn',
      port: 443,
      path: '/open-apis/im/v1/messages?receive_id_type=open_id',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        try {
          const result = JSON.parse(data);
          if (result.code === 0) {
            resolve(result.data);
          } else {
            reject(new Error(`发送消息失败: ${result.msg}`));
          }
        } catch (err) {
          reject(err);
        }
      });
    });

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

// ========== 主流程 ==========
async function main() {
  const args = process.argv.slice(2);
  if (args.length < 1) {
    console.error('用法: node send-file.js <文件路径> [接收者open_id]');
    console.error('示例: node send-file.js ./report.pdf ou_xxx');
    process.exit(1);
  }

  const filePath = args[0];
  const receiveId = args[1] || 'ou_0765c32b5ec622535c5ccc284982cfe5'; // 默认发给你

  console.log('📦 飞书文件发送工具');
  console.log('─────────────────────');

  // 加载配置
  if (!loadConfig()) {
    process.exit(1);
  }

  try {
    // Step 1: 获取 token
    console.log('🔑 获取访问令牌...');
    const token = await getTenantAccessToken();
    console.log('✅ Token 获取成功');

    // Step 2: 上传文件
    console.log(`📤 上传文件: ${path.basename(filePath)}`);
    const fileKey = await uploadFile(token, filePath);
    console.log(`✅ 文件上传成功: ${fileKey}`);

    // Step 3: 发送消息
    console.log('💬 发送文件消息...');
    const result = await sendFileMessage(token, fileKey, receiveId);
    console.log('✅ 文件发送成功!');
    console.log(`   消息ID: ${result.message_id}`);
    
  } catch (err) {
    console.error('❌ 错误:', err.message);
    process.exit(1);
  }
}

// 检查依赖
try {
  require('form-data');
  require('js-yaml');
} catch (err) {
  console.error('❌ 缺少依赖,请先运行: npm install form-data js-yaml');
  process.exit(1);
}

main();
