<template>
  <div class="icc-list">
    <!-- 搜索和筛选 -->
    <el-card class="search-card">
      <el-form :model="searchForm" inline>
        <el-form-item>
          <el-input
            v-model="searchForm.search"
            placeholder="请输入ICCID、IMSI、MSISDN或品牌"
            clearable
            @keyup.enter="handleSearch"
            style="width: 280px"
          />
        </el-form-item>
        
        <el-form-item>
          <el-select v-model="searchForm.lifeCycle" placeholder="生命周期" clearable style="width: 120px">
            <el-option label="未激活" value="0" />
            <el-option label="活跃" value="1" />
            <el-option label="已停机" value="2" />
            <el-option label="已锁定" value="3" />
            <el-option label="已过期" value="4" />
            <el-option label="已删除" value="5" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-select v-model="searchForm.paidFlag" placeholder="付费标志" clearable style="width: 120px">
            <el-option label="预付费" value="0" />
            <el-option label="后付费" value="1" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-input v-model="searchForm.brand" placeholder="品牌" clearable style="width: 120px" />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 统计信息 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value">{{ statistics.total }}</div>
            <div class="stat-label">总计</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value active">{{ statistics.active }}</div>
            <div class="stat-label">活跃</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value inactive">{{ statistics.inactive }}</div>
            <div class="stat-label">未激活</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value suspended">{{ statistics.suspended }}</div>
            <div class="stat-label">已停机</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value expired">{{ statistics.expired }}</div>
            <div class="stat-label">已过期</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="4">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-value deleted">{{ statistics.deleted }}</div>
            <div class="stat-label">已删除</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 数据表格 -->
    <el-card class="table-card">
      <el-table
        v-loading="loading"
        :data="iccList"
        stripe
        border
      >
        
        <el-table-column prop="iccid" label="ICCID" width="200" fixed="left">
          <template #default="{ row }">
            <el-link type="primary" @click="handleView(row)">
              {{ row.iccid }}
            </el-link>
          </template>
        </el-table-column>
        
        <el-table-column prop="imsi" label="IMSI" width="160" />
        <el-table-column prop="msisdn" label="MSISDN" width="150" />
        <el-table-column prop="brand" label="品牌" width="100" />
        
        <el-table-column prop="lifeCycle_display" label="生命周期" width="120">
          <template #default="{ row }">
            <el-tag :type="getLifeCycleTagType(row.lifeCycle)">
              {{ row.lifeCycle_display }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="paidFlag_display" label="付费标志" width="120" />
        
        <el-table-column prop="activeTime" label="激活时间" width="160">
          <template #default="{ row }">
            {{ formatDateTime(row.activeTime) }}
          </template>
        </el-table-column>
        
        <el-table-column prop="expTime" label="过期时间" width="160">
          <template #default="{ row }">
            {{ formatDateTime(row.expTime) }}
          </template>
        </el-table-column>
        
        <el-table-column prop="createTime" label="创建时间" width="160">
          <template #default="{ row }">
            {{ formatDateTime(row.createTime) }}
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

    <!-- 新增/编辑对话框 -->
    <ICCForm
      v-model:visible="formVisible"
      :form-data="currentICC"
      :is-edit="isEdit"
      @success="handleFormSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Download, Search } from '@element-plus/icons-vue'
import { iccApi, type ICC, type ICCStatistics } from '@/api/icc'
import ICCForm from './ICCForm.vue'

const router = useRouter()

// 响应式数据
const loading = ref(false)
const iccList = ref<ICC[]>([])
const statistics = ref<ICCStatistics>({
  total: 0,
  active: 0,
  inactive: 0,
  suspended: 0,
  expired: 0,
  deleted: 0
})

// 搜索表单
const searchForm = reactive({
  search: '',
  lifeCycle: '',
  paidFlag: '',
  brand: ''
})

// 分页
const pagination = reactive({
  page: 1,
  pageSize: 20,
  total: 0
})

// 表单相关
const formVisible = ref(false)
const currentICC = ref<ICC | null>(null)
const isEdit = ref(false)

// 选中的行
const selectedRows = ref<ICC[]>([])

// 获取ICC列表
const fetchICCList = async () => {
  try {
    loading.value = true
    const params = {
      page: pagination.page,
      page_size: pagination.pageSize,
      ...searchForm
    }
    
    const response = await iccApi.getICCs(params)
    iccList.value = response.results
    pagination.total = response.count
  } catch (error) {
    console.error('获取ICC列表失败:', error)
    ElMessage.error('获取ICC列表失败')
  } finally {
    loading.value = false
  }
}

// 获取统计信息
const fetchStatistics = async () => {
  try {
    const data = await iccApi.getICCStatistics()
    statistics.value = data
  } catch (error) {
    console.error('获取统计信息失败:', error)
  }
}

// 搜索
const handleSearch = () => {
  pagination.page = 1
  fetchICCList()
}

// 重置搜索
const handleReset = () => {
  Object.assign(searchForm, {
    search: '',
    lifeCycle: '',
    paidFlag: '',
    brand: ''
  })
  pagination.page = 1
  fetchICCList()
}

// 分页处理
const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  pagination.page = 1
  fetchICCList()
}

const handleCurrentChange = (page: number) => {
  pagination.page = page
  fetchICCList()
}

// 表格选择
const handleSelectionChange = (selection: ICC[]) => {
  selectedRows.value = selection
}

// 新增
const handleAdd = () => {
  currentICC.value = null
  isEdit.value = false
  formVisible.value = true
}

// 查看
const handleView = (row: ICC) => {
  router.push(`/icc/${row.id}`)
}

// 编辑
const handleEdit = (row: ICC) => {
  currentICC.value = { ...row }
  isEdit.value = true
  formVisible.value = true
}

// 删除
const handleDelete = async (row: ICC) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除ICC "${row.iccid}" 吗？`,
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await iccApi.deleteICC(row.id)
    ElMessage.success('删除成功')
    fetchICCList()
    fetchStatistics()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除ICC失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 导出
const handleExport = async () => {
  try {
    const blob = await iccApi.exportICC()
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `icc_export_${new Date().toISOString().split('T')[0]}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 表单成功回调
const handleFormSuccess = () => {
  formVisible.value = false
  fetchICCList()
  fetchStatistics()
}

// 获取生命周期标签类型
const getLifeCycleTagType = (lifeCycle?: string) => {
  switch (lifeCycle) {
    case '1': return 'success'  // 活跃
    case '0': return 'info'     // 未激活
    case '2': return 'warning'  // 已停机
    case '3': return 'danger'   // 已锁定
    case '4': return 'danger'   // 已过期
    case '5': return 'info'     // 已删除
    default: return ''
  }
}

// 格式化日期时间
const formatDateTime = (dateTime?: string) => {
  if (!dateTime || dateTime === 'None' || dateTime === 'null') return '-'
  
  // 如果是14位数字格式 (yyyyMMddHHmmss)
  if (dateTime.length === 14 && /^\d{14}$/.test(dateTime)) {
    const year = dateTime.substring(0, 4)
    const month = dateTime.substring(4, 6)
    const day = dateTime.substring(6, 8)
    const hour = dateTime.substring(8, 10)
    const minute = dateTime.substring(10, 12)
    const second = dateTime.substring(12, 14)
    return `${year}-${month}-${day} ${hour}:${minute}:${second}`
  }
  
  // 如果是ISO格式
  try {
    return new Date(dateTime).toLocaleString()
  } catch {
    return dateTime
  }
}

// 初始化
onMounted(() => {
  fetchICCList()
  fetchStatistics()
})
</script>

<style scoped>
.icc-list {
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

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  text-align: center;
}

.stat-content {
  padding: 10px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-value.active {
  color: #67c23a;
}

.stat-value.inactive {
  color: #909399;
}

.stat-value.suspended {
  color: #e6a23c;
}

.stat-value.expired {
  color: #f56c6c;
}

.stat-value.deleted {
  color: #909399;
}

.stat-label {
  color: #606266;
  font-size: 14px;
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
