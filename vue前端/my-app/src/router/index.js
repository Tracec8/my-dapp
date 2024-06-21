import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import Account from '../views/Account.vue'
import Main from '../views/Main.vue'
import Trade from '../views/Trade.vue'
import Market from '../views/Market.vue'
import DerivativesList from '../views/DerivativesList.vue'
Vue.use(VueRouter)
//1.创建路由组件
//2.将路由与组件进行映射
//3.创建router实例

const routes = [
    //主路由
    {
        path:'/',
        component:Main,
        redirect:'/home',// 重定向 
        children: [
            //子路由
            {path:'home', component:Home},//首页
            {path:'account', component:Account},//用户管理
            {path:'trade', component:Trade},//商品管理
            {path:'market', component:Market},//页面1
            {path:'derivatives', component:DerivativesList},//展示
        ]
    }

]

const router = new VueRouter({
    routes //(缩写) 相当于 routes: routes
})

export default router