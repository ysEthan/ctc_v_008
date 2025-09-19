<template>
  <div class="icc-detail">
    <div class="page-header">
      <el-button @click="goBack">
        <el-icon><ArrowLeft /></el-icon>
        返回
      </el-button>
      <h1>ICC详情</h1>
      <div class="header-actions">
        <el-button type="primary" @click="handleEdit">
          <el-icon><Edit /></el-icon>
          编辑
        </el-button>
      </div>
    </div>

    <div v-loading="loading" class="detail-content">
      <!-- ICC完整信息卡片 -->
      <el-row :gutter="20">
        <el-col :span="24">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <span>ICC完整信息</span>
              </div>
            </template>
            
             <el-row :gutter="20">
               <!-- 第一列：核心标识信息（垂直排列） -->
               <el-col :span="4">
                 <div class="info-column">
                   <div class="info-item">
                     <div class="info-label">ICCID</div>
                     <div class="info-value">
                       <el-tag type="primary" size="small">{{ iccData?.iccid }}</el-tag>
                     </div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">用户ID</div>
                     <div class="info-value">{{ iccData?.userid || '-' }}</div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">IMSI</div>
                     <div class="info-value">{{ iccData?.imsi || '-' }}</div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">MSISDN</div>
                     <div class="info-value">{{ iccData?.msisdn || '-' }}</div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">设备状态</div>
                     <div class="info-value">
                       <el-tag :type="getHlrStateTagType(iccData?.hlrState)" size="small">
                         {{ iccData?.hlrState_display || '-' }}
                       </el-tag>
                     </div>
                   </div>
                 </div>
        </el-col>

               <!-- 第二列：品牌信息 -->
               <el-col :span="4">
                 <div class="info-column">
                   <div class="info-item">
                     <div class="info-label">品牌</div>
                     <div class="info-value">{{ iccData?.brand || '-' }}</div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">费率计划ID</div>
                     <div class="info-value">{{ iccData?.rateplanId || '-' }}</div>
              </div>
                   <div class="info-item">
                     <div class="info-label">付费标志</div>
                     <div class="info-value">
                       <el-tag :type="iccData?.paidFlag === '1' ? 'success' : 'warning'" size="small">
                  {{ iccData?.paidFlag_display || '-' }}
                </el-tag>
                     </div>
                   </div>
                   <div class="info-item">
                     <div class="info-label"></div>
                     <div class="info-value"></div>
                   </div>
                   <div class="info-item">
                     <div class="info-label"></div>
                     <div class="info-value"></div>
                   </div>
                 </div>
               </el-col>
               
               <!-- 第三列：时间信息 -->
               <el-col :span="4">
                 <div class="info-column">
                   <div class="info-item">
                     <div class="info-label">激活时间</div>
                     <div class="info-value">{{ formatDateTime(iccData?.activeTime) }}</div>
                   </div>
                   <div class="info-item">
                     <div class="info-label">生效时间</div>
                     <div class="info-value">{{ formatDateTime(iccData?.effTime) }}</div>
                   </div>
               <div class="info-item">
                 <div class="info-label">过期时间</div>
                 <div class="info-value">{{ formatDateTime(iccData?.expTime) }}</div>
               </div>
               <div class="info-item">
                 <div class="info-label">激活类型</div>
                 <div class="info-value">{{ iccData?.activeType || '-' }}</div>
               </div>
               <div class="info-item">
                 <div class="info-label"></div>
                 <div class="info-value"></div>
               </div>
                 </div>
               </el-col>
               
               <!-- 第四列：时间和其他信息 -->
               <el-col :span="6">
                 <div class="info-column">
                    <div class="info-item">
                      <div class="info-label">创建时间</div>
                      <div class="info-value">{{ formatDateTime(iccData?.createTime) }}</div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">生命周期时间</div>
                      <div class="info-value">{{ formatDateTime(iccData?.lifeCycleTime) }}</div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">最后激活时间</div>
                      <div class="info-value">
                        {{ formatDate(iccData?.activeDeadline) }}
                        <span v-if="!iccData?.activeDeadline" class="empty-hint">(未激活时显示)</span>
                      </div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">有效期时长</div>
                      <div class="info-value">
                        {{ iccData?.validityTime || '-' }}
                        <span v-if="!iccData?.validityTime" class="empty-hint">(未激活时显示)</span>
                      </div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">生命周期状态</div>
                      <div class="info-value">
                        <el-tag :type="getLifeCycleTagType(iccData?.lifeCycle)" size="small">
                          {{ iccData?.lifeCycle_display || '-' }}
                        </el-tag>
                      </div>
                    </div>
                 </div>
               </el-col>
               
               <!-- 第五列：其他信息 -->
               <el-col :span="6">
                 <div class="info-column">
                    <div class="info-item">
                      <div class="info-label"></div>
                      <div class="info-value"></div>
                    </div>
                    <div class="info-item">
                      <div class="info-label"></div>
                      <div class="info-value"></div>
                    </div>
                    <div class="info-item">
                      <div class="info-label"></div>
                      <div class="info-value"></div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">有效期单位</div>
                      <div class="info-value">{{ iccData?.validityUnit_display || '-' }}</div>
                    </div>
                    <div class="info-item">
                      <div class="info-label">停机原因</div>
                      <div class="info-value">{{ iccData?.suspendReason_display || '-' }}</div>
                    </div>
                   </div>
                 </el-col>
             </el-row>
          </el-card>
        </el-col>
      </el-row>

      <!-- 订阅信息卡片 -->
      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="24">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <span>订阅信息</span>
                <el-button type="primary" size="small" @click="fetchSubscriptions">
                  <el-icon><Refresh /></el-icon>
                  刷新
                </el-button>
              </div>
            </template>
            
            <div v-loading="subscriptionLoading">
              <el-table :data="subscriptions" border style="width: 100%">
                <el-table-column prop="subscriptionId" label="订阅ID" width="180" />
                <el-table-column prop="productId" label="产品ID" width="120" />
                <el-table-column prop="productFlag_display" label="产品标志" width="100">
                  <template #default="{ row }">
                    <el-tag :type="row.productFlag === '1' ? 'success' : 'warning'">
                      {{ row.productFlag_display }}
                </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="status_display" label="状态" width="100">
                  <template #default="{ row }">
                    <el-tag :type="getSubscriptionStatusTagType(row.status)">
                      {{ row.status_display }}
                </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="priority_display" label="优先级" width="100" />
                <el-table-column prop="effTime" label="生效时间" width="160">
                  <template #default="{ row }">
                    {{ formatDateTime(row.effTime) }}
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
              </el-table>
              
              <div v-if="subscriptions.length === 0 && !subscriptionLoading" class="empty-data">
                <el-empty description="暂无订阅信息" />
              </div>
              </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 用量信息卡片 -->
      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="24">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <span>用量信息</span>
                <el-button type="primary" size="small" @click="fetchUsages">
                  <el-icon><Refresh /></el-icon>
                  刷新
                </el-button>
              </div>
            </template>
            
            <div v-loading="usageLoading">
              <!-- 统计卡片 -->
              <el-row :gutter="20" style="margin-bottom: 20px;">
                <el-col :span="6">
                  <el-card class="stat-card">
                    <div class="stat-content-new">
                      <div class="stat-icon-new">
                        <el-icon size="20" color="#409EFF"><Calendar /></el-icon>
                      </div>
                      <div class="stat-info-new">
                        <div class="stat-value-new">{{ activeDays }}</div>
                        <div class="stat-label-new">活跃天数</div>
                      </div>
                    </div>
                  </el-card>
                </el-col>
                <el-col :span="6">
                  <el-card class="stat-card">
                    <div class="stat-content-new">
                      <div class="stat-icon-new">
                        <el-icon size="20" color="#67C23A"><DataAnalysis /></el-icon>
                      </div>
                      <div class="stat-info-new">
                        <div class="stat-value-new">{{ totalUsage }} MB</div>
                        <div class="stat-label-new">用量汇总</div>
                      </div>
                    </div>
                  </el-card>
                </el-col>
                <el-col :span="6">
                  <el-card class="stat-card chart-card">
                    <div class="chart-header">
                      <div class="chart-title">最近7天用量</div>
                      <div class="chart-icon">
                        <el-icon size="16" color="#E6A23C"><TrendCharts /></el-icon>
                      </div>
                    </div>
                    <div class="chart-container">
                      <div class="chart-bars">
                        <div 
                          v-for="(item, index) in last7DaysUsage" 
                          :key="index"
                          class="chart-bar-item"
                        >
                          <div class="bar-container">
                            <div 
                              class="bar" 
                              :style="{ height: getBarHeight(item.usage) + '%' }"
                            ></div>
                          </div>
                          <div class="bar-label">{{ item.date }}</div>
                          <div class="bar-value">{{ item.usage }}MB</div>
                        </div>
                      </div>
                    </div>
                  </el-card>
                </el-col>
                <el-col :span="6">
                  <el-card class="stat-card pie-chart-card">
                    <div class="chart-header">
                      <div class="chart-title">MNC用量分布</div>
                      <div class="chart-icon">
                        <el-icon size="16" color="#F56C6C"><PieChart /></el-icon>
                      </div>
                    </div>
                    <div class="pie-chart-container">
                      <div class="pie-chart">
                        <div 
                          v-for="(item, index) in mncUsageData" 
                          :key="index"
                          class="pie-segment"
                          :style="{ 
                            transform: `rotate(${item.startAngle}deg)`,
                            background: item.color
                          }"
                        ></div>
                      </div>
                      <div class="pie-legend">
                        <div 
                          v-for="(item, index) in mncUsageData" 
                          :key="index"
                          class="legend-item"
                        >
                          <div class="legend-color" :style="{ backgroundColor: item.color }"></div>
                          <div class="legend-text">
                            <div class="legend-label">{{ item.mnc }}</div>
                            <div class="legend-value">{{ item.usage }}MB</div>
                          </div>
                        </div>
                      </div>
                    </div>
          </el-card>
        </el-col>
              </el-row>
              
              <el-table :data="usages" border style="width: 100%">
                <el-table-column prop="usageDate" label="用量日期" width="120" />
                <el-table-column prop="productId" label="产品ID" width="120" />
                <el-table-column prop="subscriptionId" label="订阅ID" width="180" />
                <el-table-column prop="usageType_display" label="用量类型" width="100" />
                <el-table-column prop="callType_display" label="呼叫类型" width="100" />
                <el-table-column prop="visitMnc" label="MCC-MNC" width="120" />
                <el-table-column label="用量(MB)" width="120">
                  <template #default="{ row }">
                    {{ formatUsageToMB(row.usage, row.unit) }}
            </template>
                </el-table-column>
              </el-table>
              
              <div v-if="usages.length === 0 && !usageLoading" class="empty-data">
                <el-empty description="暂无用量信息" />
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 编辑对话框 -->
    <ICCForm
      v-model:visible="editVisible"
      :form-data="iccData"
      :is-edit="true"
      @success="handleEditSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowLeft, Edit, Refresh, Calendar, DataAnalysis, TrendCharts, PieChart } from '@element-plus/icons-vue'
import { iccApi, type ICC } from '@/api/icc'
import { subscriptionApi, type Subscription } from '@/api/subscription'
import { usageApi, type Usage } from '@/api/usage'
import ICCForm from './ICCForm.vue'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const iccData = ref<ICC | null>(null)
const editVisible = ref(false)

// 订阅信息相关
const subscriptionLoading = ref(false)
const subscriptions = ref<Subscription[]>([])

// 用量信息相关
const usageLoading = ref(false)
const usages = ref<Usage[]>([])

// 计算活跃天数（去重日期）
const activeDays = computed(() => {
  if (!usages.value.length) return 0
  const uniqueDates = new Set(usages.value.map(usage => usage.usageDate))
  return uniqueDates.size
})

// 计算用量汇总（MB）
const totalUsage = computed(() => {
  if (!usages.value.length) return '0.00'
  const total = usages.value.reduce((sum, usage) => {
    const usageValue = typeof usage.usage === 'string' ? parseFloat(usage.usage) : usage.usage
    if (isNaN(usageValue)) return sum
    
    let mbValue = usageValue
    if (usage.unit) {
      switch (usage.unit.toLowerCase()) {
        case 'byte':
        case 'b':
          mbValue = usageValue / (1024 * 1024) // 字节转MB
          break
        case 'kb':
        case 'k':
          mbValue = usageValue / 1024 // KB转MB
          break
        case 'gb':
        case 'g':
          mbValue = usageValue * 1024 // GB转MB
          break
        case 'tb':
        case 't':
          mbValue = usageValue * 1024 * 1024 // TB转MB
          break
        case 'mb':
        case 'm':
          mbValue = usageValue // 已经是MB
          break
        default:
          // 如果unit不是标准单位，默认按字节处理
          mbValue = usageValue / (1024 * 1024)
          break
      }
    } else {
      // 如果unit为空，默认按字节处理
      mbValue = usageValue / (1024 * 1024)
    }
    return sum + mbValue
  }, 0)
  return total.toFixed(2)
})

// 计算最近7天每天用量
const last7DaysUsage = computed(() => {
  if (!usages.value.length) return []
  
  // 生成最近7天的日期
  const last7Days = []
  for (let i = 6; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    const dateStr = date.toISOString().split('T')[0].replace(/-/g, '')
    last7Days.push({
      date: date.toISOString().split('T')[0].substring(5), // MM-DD格式
      fullDate: dateStr,
      usage: 0
    })
  }
  
  // 按日期汇总用量
  const usageByDate = new Map()
  usages.value.forEach(usage => {
    if (usage.usageDate) {
      const usageValue = typeof usage.usage === 'string' ? parseFloat(usage.usage) : usage.usage
      if (isNaN(usageValue)) return
      
      let mbValue = usageValue
      if (usage.unit) {
        switch (usage.unit.toLowerCase()) {
          case 'byte':
          case 'b':
            mbValue = usageValue / (1024 * 1024) // 字节转MB
            break
          case 'kb':
          case 'k':
            mbValue = usageValue / 1024 // KB转MB
            break
          case 'gb':
          case 'g':
            mbValue = usageValue * 1024 // GB转MB
            break
          case 'tb':
          case 't':
            mbValue = usageValue * 1024 * 1024 // TB转MB
            break
          case 'mb':
          case 'm':
            mbValue = usageValue // 已经是MB
            break
          default:
            // 如果unit不是标准单位，默认按字节处理
            mbValue = usageValue / (1024 * 1024)
            break
        }
      } else {
        // 如果unit为空，默认按字节处理
        mbValue = usageValue / (1024 * 1024)
      }
      
      const currentUsage = usageByDate.get(usage.usageDate) || 0
      usageByDate.set(usage.usageDate, currentUsage + mbValue)
    }
  })
  
  // 填充最近7天的数据
  return last7Days.map(day => ({
    date: day.date,
    fullDate: day.fullDate,
    usage: usageByDate.get(day.fullDate) ? usageByDate.get(day.fullDate).toFixed(2) : '0.00'
  }))
})

// 计算柱状图高度
const getBarHeight = (usage: string) => {
  const usageValue = parseFloat(usage)
  if (usageValue === 0) return 0
  
  // 找到最大值用于计算比例
  const maxUsage = Math.max(...last7DaysUsage.value.map(item => parseFloat(item.usage)))
  if (maxUsage === 0) return 0
  
  return Math.max((usageValue / maxUsage) * 100, 5) // 最小高度5%
}

// 计算MNC用量分布
const mncUsageData = computed(() => {
  if (!usages.value.length) return []
  
  // 按MNC汇总用量
  const usageByMnc = new Map()
  usages.value.forEach(usage => {
    if (usage.visitMnc) {
      const usageValue = typeof usage.usage === 'string' ? parseFloat(usage.usage) : usage.usage
      if (isNaN(usageValue)) return
      
      let mbValue = usageValue
      if (usage.unit) {
        switch (usage.unit.toLowerCase()) {
          case 'byte':
          case 'b':
            mbValue = usageValue / (1024 * 1024) // 字节转MB
            break
          case 'kb':
          case 'k':
            mbValue = usageValue / 1024 // KB转MB
            break
          case 'gb':
          case 'g':
            mbValue = usageValue * 1024 // GB转MB
            break
          case 'tb':
          case 't':
            mbValue = usageValue * 1024 * 1024 // TB转MB
            break
          case 'mb':
          case 'm':
            mbValue = usageValue // 已经是MB
            break
          default:
            // 如果unit不是标准单位，默认按字节处理
            mbValue = usageValue / (1024 * 1024)
            break
        }
      } else {
        // 如果unit为空，默认按字节处理
        mbValue = usageValue / (1024 * 1024)
      }
      
      const currentUsage = usageByMnc.get(usage.visitMnc) || 0
      usageByMnc.set(usage.visitMnc, currentUsage + mbValue)
    }
  })
  
  // 转换为数组并排序
  const mncData = Array.from(usageByMnc.entries())
    .map(([mnc, usage]) => ({
      mnc,
      usage: usage.toFixed(2)
    }))
    .sort((a, b) => parseFloat(b.usage) - parseFloat(a.usage))
  
  // 计算饼图角度和颜色
  const totalUsage = mncData.reduce((sum, item) => sum + parseFloat(item.usage), 0)
  const colors = ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399', '#9C27B0', '#FF9800', '#4CAF50']
  
  let currentAngle = 0
  return mncData.map((item, index) => {
    const percentage = parseFloat(item.usage) / totalUsage
    const angle = percentage * 360
    const startAngle = currentAngle
    currentAngle += angle
    
    return {
      ...item,
      percentage: (percentage * 100).toFixed(1),
      angle,
      startAngle,
      color: colors[index % colors.length]
    }
  })
})

// 获取ICC详情
const fetchICCDetail = async () => {
  try {
    loading.value = true
    const id = Number(route.params.id)
    const data = await iccApi.getICC(id)
    iccData.value = data
    
    // 获取ICC详情后，同时获取订阅和用量信息
    await Promise.all([
      fetchSubscriptions(),
      fetchUsages()
    ])
  } catch (error) {
    console.error('获取ICC详情失败:', error)
    ElMessage.error('获取ICC详情失败')
    goBack()
  } finally {
    loading.value = false
  }
}

// 获取订阅信息
const fetchSubscriptions = async () => {
  if (!iccData.value?.id) return
  
  try {
    subscriptionLoading.value = true
    const response = await subscriptionApi.getSubscriptions({
      icc: iccData.value.id,
      page_size: 100
    })
    subscriptions.value = response.results
  } catch (error) {
    console.error('获取订阅信息失败:', error)
    ElMessage.error('获取订阅信息失败')
  } finally {
    subscriptionLoading.value = false
  }
}

// 获取用量信息
const fetchUsages = async () => {
  if (!iccData.value?.iccid) return
  
  try {
    usageLoading.value = true
    const response = await usageApi.getUsages({
      iccid: iccData.value.iccid,
      page_size: 100
    })
    usages.value = response.results
  } catch (error) {
    console.error('获取用量信息失败:', error)
    ElMessage.error('获取用量信息失败')
  } finally {
    usageLoading.value = false
  }
}

// 返回
const goBack = () => {
  router.go(-1)
}

// 编辑
const handleEdit = () => {
  editVisible.value = true
}

// 编辑成功
const handleEditSuccess = () => {
  editVisible.value = false
  fetchICCDetail()
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

// 获取设备状态标签类型
const getHlrStateTagType = (hlrState?: string) => {
  switch (hlrState) {
    case 'A': return 'success'  // 正常
    case 'B': return 'warning'  // 丢失
    case 'G': return 'warning'  // 暂停
    case 'D': return 'danger'   // 已删除
    case 'I': return 'info'     // 预删除
    default: return ''
  }
}

// 获取订阅状态标签类型
const getSubscriptionStatusTagType = (status?: string) => {
  switch (status) {
    case '1': return 'success'  // 正常
    case '0': return 'info'     // 订阅中
    case '2': return 'warning'  // 非活跃
    case '3': return 'danger'   // 已过期
    case '4': return 'warning'  // 退订中
    case '5': return 'danger'   // 已锁定
    default: return ''
  }
}

// 格式化用量为MB
const formatUsageToMB = (usage?: number | string, unit?: string) => {
  if (!usage) return '-'
  const usageValue = typeof usage === 'string' ? parseFloat(usage) : usage
  if (isNaN(usageValue)) return '-'
  let mbValue = usageValue
  if (unit) {
    switch (unit.toLowerCase()) {
      case 'byte':
      case 'b':
        mbValue = usageValue / (1024 * 1024) // 字节转MB
        break
      case 'kb':
      case 'k':
        mbValue = usageValue / 1024 // KB转MB
        break
      case 'gb':
      case 'g':
        mbValue = usageValue * 1024 // GB转MB
        break
      case 'tb':
      case 't':
        mbValue = usageValue * 1024 * 1024 // TB转MB
        break
      case 'mb':
      case 'm':
        mbValue = usageValue // 已经是MB
        break
      default:
        // 如果unit不是标准单位，默认按字节处理
        mbValue = usageValue / (1024 * 1024)
        break
    }
  } else {
    // 如果unit为空，默认按字节处理
    mbValue = usageValue / (1024 * 1024)
  }
  return mbValue.toFixed(2)
}

// 格式化日期时间
const formatDateTime = (dateTime?: string) => {
  if (!dateTime) return '-'
  
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

// 格式化日期
const formatDate = (date?: string) => {
  if (!date) return '-'
  
  // 如果是8位数字格式 (yyyyMMdd)
  if (date.length === 8 && /^\d{8}$/.test(date)) {
    const year = date.substring(0, 4)
    const month = date.substring(4, 6)
    const day = date.substring(6, 8)
    return `${year}-${month}-${day}`
  }
  
  return date
}

// 初始化
onMounted(() => {
  fetchICCDetail()
})
</script>

<style scoped>
.icc-detail {
  padding: 20px;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 20px;
}

.page-header h1 {
  margin: 0;
  color: #2c3e50;
  flex: 1;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.detail-content {
  min-height: 400px;
}

.info-card {
  height: 100%;
}

.card-header {
  font-weight: bold;
  color: #2c3e50;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.empty-data {
  text-align: center;
  padding: 20px;
}

.info-column {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 0;
  height: 100%;
}

.info-item {
  display: flex;
  border-bottom: 1px solid #dcdfe6;
  min-height: 40px;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  background-color: #f5f7fa;
  padding: 8px 10px;
  border-right: 1px solid #dcdfe6;
  font-weight: 500;
  color: #606266;
  width: 100px;
  display: flex;
  align-items: center;
  font-size: 13px;
  word-break: break-all;
  line-height: 1.4;
  flex-shrink: 0;
}

.info-value {
  padding: 8px 10px;
  flex: 1;
  display: flex;
  align-items: center;
  font-size: 13px;
  color: #303133;
  word-break: break-all;
  line-height: 1.4;
  overflow: hidden;
}

.empty-hint {
  font-size: 11px;
  color: #909399;
  margin-left: 4px;
}

/* 统计卡片样式 */
.stat-card {
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  min-height: 200px; /* 统一卡片最小高度 */
}

.stat-card :deep(.el-card__body) {
  padding: 16px;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.stat-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background-color: #f0f9ff;
}

.stat-info {
  flex: 1;
}

.stat-label {
  font-size: 16px;
  color: #606266;
  margin-bottom: 6px;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #303133;
  line-height: 1;
}

/* 新的统计卡片样式 - 参考图片布局 */
.stat-content-new {
  position: relative;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 20px;
}

.stat-icon-new {
  position: absolute;
  top: 16px;
  left: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background-color: #f0f9ff;
}

.stat-info-new {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
  width: 100%;
}

.stat-value-new {
  font-size: 36px;
  font-weight: 700;
  color: #303133;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label-new {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

/* 图表卡片样式 */
.chart-card {
  /* 使用统一的stat-card最小高度 */
}

.chart-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.chart-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.chart-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  background-color: #fdf6ec;
}

.chart-container {
  height: 120px;
  display: flex;
  align-items: end;
}

.chart-bars {
  display: flex;
  align-items: end;
  justify-content: space-between;
  width: 100%;
  height: 100%;
  gap: 4px;
}

.chart-bar-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100%;
  position: relative;
}

.bar-container {
  flex: 1;
  display: flex;
  align-items: end;
  justify-content: center;
  width: 100%;
  margin-bottom: 8px;
}

.bar {
  width: 100%;
  max-width: 20px;
  background: linear-gradient(to top, #E6A23C, #F7BA2A);
  border-radius: 2px 2px 0 0;
  transition: all 0.3s ease;
  min-height: 2px;
}

.bar:hover {
  background: linear-gradient(to top, #D4941E, #E6A23C);
  transform: scaleY(1.05);
}

.bar-label {
  font-size: 10px;
  color: #909399;
  margin-bottom: 2px;
  text-align: center;
}

.bar-value {
  font-size: 9px;
  color: #606266;
  text-align: center;
  font-weight: 500;
}

/* 饼图卡片样式 */
.pie-chart-card {
  /* 使用统一的stat-card最小高度 */
}

.pie-chart-container {
  display: flex;
  align-items: center;
  justify-content: center; /* 饼图和图例整体居中 */
  gap: 16px;
  height: 120px;
}

.pie-chart {
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: conic-gradient(
    from 0deg,
    #409EFF 0deg 120deg,
    #67C23A 120deg 240deg,
    #E6A23C 240deg 360deg
  );
  flex-shrink: 0;
}

.pie-segment {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  clip-path: polygon(50% 50%, 50% 0%, 100% 0%, 100% 100%, 0% 100%, 0% 0%);
  transform-origin: 50% 50%;
}

.pie-legend {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
  max-height: 100%;
  overflow-y: auto;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 2px 0;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 2px;
  flex-shrink: 0;
}

.legend-text {
  flex: 1;
  min-width: 0;
}

.legend-label {
  font-size: 12px;
  color: #303133;
  font-weight: 500;
  margin-bottom: 1px;
}

.legend-value {
  font-size: 11px;
  color: #909399;
}
</style>
