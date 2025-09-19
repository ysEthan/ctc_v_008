<template>
  <div class="usage-list">
    <!-- 搜索和筛选 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item>
          <el-input
            v-model="searchForm.search"
            placeholder="请输入产品ID、订阅ID或访问地MCC"
            clearable
            @keyup.enter="handleSearch"
            style="width: 280px"
          />
        </el-form-item>
        
        <el-form-item>
          <el-select v-model="searchForm.usageType" placeholder="用量类型" clearable style="width: 120px">
            <el-option label="数据" value="dat" />
            <el-option label="短信" value="sms" />
            <el-option label="语音" value="voc" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-select v-model="searchForm.callType" placeholder="呼叫类型" clearable style="width: 120px">
            <el-option label="主叫" value="0" />
            <el-option label="被叫" value="1" />
            <el-option label="全部" value="*" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="usageList"
        stripe
        border
      >
        
        <el-table-column prop="usageDate" label="用量日期" width="120" fixed="left" />
        
        <el-table-column prop="productId" label="产品ID" width="120" />
        <el-table-column prop="subscriptionId" label="订阅ID" width="200" />
        
        <el-table-column prop="visitMnc" label="MCC-MNC" width="120" />
        
        <el-table-column prop="formatted_usage" label="用量(MB)" width="120">
          <template #default="{ row }">
            {{ formatUsageToMB(row.usage, row.unit) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleView(row)">查看</el-button>
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          :current-page="pagination.page"
          :page-size="pagination.pageSize"
          :total="pagination.total"
          layout="total, prev, pager, next, jumper, sizes"
          :page-sizes="[10, 20, 50, 100, 200]"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { usageApi, type Usage } from '@/api/usage'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const usageList = ref<Usage[]>([])

// 搜索表单
const searchForm = reactive({
  search: '',
  usageType: '',
  callType: ''
})

// 分页
const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

// 获取用量列表
const fetchUsageList = async () => {
  try {
    loading.value = true
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm
    }
    
    const response = await usageApi.getUsages(params)
    usageList.value = response.results
    pagination.total = response.count
  } catch (error) {
    console.error('获取用量列表失败:', error)
    ElMessage.error('获取用量列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.page = 1
  fetchUsageList()
}

// 重置搜索
const handleReset = () => {
  Object.assign(searchForm, {
    search: '',
    usageType: '',
    callType: ''
  })
  pagination.page = 1
  fetchUsageList()
}

// 分页处理
const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.page = 1
  fetchUsageList()
}

const handleCurrentChange = (page: number) => {
  pagination.page = page
  fetchUsageList()
}

// 新增
const handleAdd = () => {
  ElMessage.info('新增功能待实现')
}

// 查看
const handleView = (row: Usage) => {
  ElMessage.info('查看功能待实现')
}

// 编辑
const handleEdit = (row: Usage) => {
  ElMessage.info('编辑功能待实现')
}

// 删除
const handleDelete = async (row: Usage) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除这条用量记录吗？`,
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await usageApi.deleteUsage(row.id)
    ElMessage.success('删除成功')
    fetchUsageList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除用量失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 导出
const handleExport = async () => {
  try {
    const blob = await usageApi.exportUsage()
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `usage_export_${new Date().toISOString().split('T')[0]}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 获取用量类型标签类型
const getUsageTypeTagType = (usageType?: string) => {
  switch (usageType) {
    case 'dat': return 'primary'  // 数据
    case 'sms': return 'success'  // 短信
    case 'voc': return 'warning'  // 语音
    default: return ''
  }
}

// 格式化日期时间
const formatDateTime = (dateTime?: string) => {
  if (!dateTime) return '-'
  
  try {
    return new Date(dateTime).toLocaleString()
  } catch {
    return dateTime
  }
}

// 格式化用量为MB显示
const formatUsageToMB = (usage?: number | string, unit?: string) => {
  if (!usage) return '-'
  
  const usageValue = typeof usage === 'string' ? parseFloat(usage) : usage
  if (isNaN(usageValue)) return '-'
  
  // 根据单位转换为MB
  let mbValue = usageValue
  if (unit) {
    switch (unit.toLowerCase()) {
      case 'kb':
      case 'k':
        mbValue = usageValue / 1024
        break
      case 'gb':
      case 'g':
        mbValue = usageValue * 1024
        break
      case 'tb':
      case 't':
        mbValue = usageValue * 1024 * 1024
        break
      case 'mb':
      case 'm':
      default:
        mbValue = usageValue
        break
    }
  }
  
  // 保留2位小数
  return mbValue.toFixed(2)
}

// 初始化
onMounted(() => {
  fetchUsageList()
})
</script>

<style scoped>
.usage-list {
  padding: 20px;
}


.search-card {
  margin-bottom: 20px;
}

/* 紧凑筛选区域：减少外边距与内边距，保持控件尺寸不变 */
:deep(.search-card .el-card__body) {
  padding: 8px 12px; /* 默认20px，压缩为约一半 */
  padding-left: 20px; /* 左侧略加一点，让输入框与表格对齐 */
}

:deep(.search-card .el-form) {
  margin-bottom: 0; /* 去掉表单底部空隙 */
}

:deep(.search-card .el-form-item) {
  margin-right: 8px; /* 默认大约16px，压缩 */
  margin-bottom: 0; /* 去掉行间距，降低整体高度 */
}

.table-card {
  margin-bottom: 20px;
}

.pagination-container {
  display: flex;
  justify-content: flex-start;
  margin-top: 20px;
}

/* Responsive Table 样式 - 参考Bootstrap风格 */
:deep(.el-table) {
  font-size: 14px;
  border: 1px solid #ddd;
  border-collapse: collapse;
  background-color: #fff;
}

:deep(.el-table .el-table__header) {
  background-color: #f8f8f8;
}

:deep(.el-table .el-table__header th) {
  background-color: #f8f8f8;
  border: 1px solid #ddd;
  font-weight: bold;
  color: #333;
  padding: 6px 12px;
  height: 32px;
  text-align: left;
}

:deep(.el-table .el-table__header .cell) {
  padding: 6px 12px;
  line-height: 1.3;
  font-weight: bold;
}

:deep(.el-table .el-table__row) {
  height: 29px;
  border-bottom: 1px solid #ddd;
}

:deep(.el-table .el-table__row:hover) {
  background-color: #f5f5f5;
}

:deep(.el-table .el-table__body tr td) {
  border: 1px solid #ddd;
  padding: 0;
  vertical-align: middle;
}

:deep(.el-table .el-table__body tr td .cell) {
  padding: 4px 12px;
  line-height: 1.3;
}

/* 条纹样式 */
:deep(.el-table .el-table__row--striped) {
  background-color: #f9f9f9;
}

:deep(.el-table .el-table__row--striped:hover) {
  background-color: #f5f5f5;
}

/* 表格边框 */
:deep(.el-table--border) {
  border: 1px solid #ddd;
}

:deep(.el-table--border .el-table__cell) {
  border-right: 1px solid #ddd;
}

:deep(.el-table--border .el-table__header .el-table__cell) {
  border-right: 1px solid #ddd;
}

/* 紧凑按钮样式 */
:deep(.el-table .el-button--small) {
  padding: 4px 8px;
  font-size: 12px;
  border-radius: 3px;
}
</style>
