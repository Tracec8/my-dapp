<template>
  <div class="home">
    <h1>欢迎来到金融衍生品交易系统</h1>
    <p>您可以在本系统中进行基于区块链的金融衍生品交易。</p>
    <div class="features">
      <div class="feature">
        <el-button @click="goToMarket" type="primary">查看交易市场</el-button>
        <p>浏览最新的金融衍生品交易市场情况。</p>
      </div>
      <div class="feature">
        <el-button @click="goToCreateOrder" type="success">创建交易订单</el-button>
        <p>创建您自己的金融衍生品交易订单。</p>
      </div>
      <div class="feature">
        <el-button @click="goToAccount" type="info">查询信息</el-button>
        <p>查看您的金融衍生品合约信息。</p>
      </div>
    </div>
    <div class="block">
      <span class="demonstration"></span>
      <el-carousel height="300px">
        <el-carousel-item v-for="item in 4" :key="item">
          <img :src="getImageUrl(item)" alt="Carousel Image" class="carousel-image">
          <h3 class="small">{{ item }}</h3>
        </el-carousel-item>
      </el-carousel>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      // 模拟用户数据
      user: {
        name: '张三',
        accountBalance: 100.5,
        transactionHistory: [
          { id: 1, type: '购买', amount: 50, date: '2024-03-28' },
          { id: 2, type: '出售', amount: 30.5, date: '2024-03-29' },
        ],
      },
    };
  },
  methods: {
    goToMarket() {
      //使用Vue Router编程式导航跳转到交易市场页面
      this.$router.push('/market');
    },
    goToCreateOrder() {
      // 使用Vue Router的编程式导航跳转到创建订单页面
      this.$router.push('/trade');
    },
    goToAccount() {
      // 使用Vue Router的编程式导航跳转到账户管理页面
      this.$router.push('/account');
    },
    getImageUrl(item) {
      //根据item的值返回对应的图片路径
      switch (item) {
        case 1:
          return require('../assets/images/blockChain1.png');
        case 2:
          return require('../assets/images/The-Crypto-Derivatives-Exchange-Development.png');
        case 3:
          return require('../assets/images/Defi.png');
        case 4:
          return require('../assets/images/blockChain.png');
      }
    }
  }
};
</script>

<style>
.home {
  text-align: center;
  margin-top: 20px;
}

.features {
  display: flex;
  justify-content: space-around;
  margin-top: 40px;
}

.feature {
  width: 30%;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 20px;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.feature h2 {
  margin-bottom: 10px;
}

.feature p {
  font-size: 14px;
}

.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 150px;
  margin: 0;
}

.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n+1) {
  background-color: #d3dce6;
}

.carousel-image {
  width: 1620px;
  height: 374px;
}
</style>
