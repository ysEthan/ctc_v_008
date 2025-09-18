"""
Celery Beat 定时任务配置
"""
from celery.schedules import crontab, timedelta

# 定时任务配置
CELERY_BEAT_SCHEDULE = {
    # 文档扫描任务 - 每天0点、8点、16点执行
    'scan-documents': {
        'task': 'tasks.document_scan.scan_and_process_documents',
        'schedule': crontab(hour='0,8,16'),  # 每天0点、8点、16点执行
        'options': {
            'queue': 'celery',
            'routing_key': 'celery',
        }
    },
    
    # 清理旧文档任务 - 每天凌晨2点执行
    'cleanup-old-documents': {
        'task': 'tasks.document_scan.cleanup_old_documents',
        'schedule': crontab(minute=0, hour=2),  # 每天凌晨2点执行
        'options': {
            'queue': 'celery',
            'routing_key': 'celery',
        }
    },
}






