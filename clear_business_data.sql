-- 清空业务数据但保留用户数据的SQL脚本
-- 执行前请确保已备份重要数据！

-- 禁用外键检查（MySQL）
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 删除用量数据（依赖订阅表）
DELETE FROM usage_usage;

-- 2. 删除订阅数据（依赖ICC表）
DELETE FROM subscription_subscription;

-- 3. 删除ICC卡数据
DELETE FROM icc_icc;

-- 4. 删除错误案例（依赖文档表）
DELETE FROM document_badcase;

-- 5. 删除文档记录
DELETE FROM document_document;

-- 6. 删除邮箱验证记录
DELETE FROM auth_email_verification;

-- 7. 删除登录日志
DELETE FROM auth_login_log;

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 重置自增ID（可选，让新数据从1开始）
ALTER TABLE usage_usage AUTO_INCREMENT = 1;
ALTER TABLE subscription_subscription AUTO_INCREMENT = 1;
ALTER TABLE icc_icc AUTO_INCREMENT = 1;
ALTER TABLE document_badcase AUTO_INCREMENT = 1;
ALTER TABLE document_document AUTO_INCREMENT = 1;
ALTER TABLE auth_email_verification AUTO_INCREMENT = 1;
ALTER TABLE auth_login_log AUTO_INCREMENT = 1;

-- 显示清空结果
SELECT 'Business data cleared successfully!' as message;
SELECT COUNT(*) as remaining_users FROM auth_user;

