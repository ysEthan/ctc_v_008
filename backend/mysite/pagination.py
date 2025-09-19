"""
自定义分页器
"""
from rest_framework.pagination import PageNumberPagination


class CustomPageNumberPagination(PageNumberPagination):
    """
    自定义分页器
    支持通过page_size参数动态设置每页记录数
    """
    page_size = 20  # 默认每页记录数
    page_size_query_param = 'page_size'  # 允许客户端通过此参数设置每页记录数
    max_page_size = 200  # 最大每页记录数限制
    page_query_param = 'page'  # 页码参数名
