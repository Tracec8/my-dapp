<template>
    <div class="header-container">
        <div class="l-content">
            <el-button @click="handleMenu" icon="el-icon-menu" size="mini"></el-button>
            <!-- 面包屑 -->
            <span class="text">首页</span>
        </div>
        <div class="r-content">
            <el-dropdown @command="handleDropdownCommand">
                <span class="el-dropdown-link">
                    <img class="user" src="../assets/images/user.png" alt="">
                </span>
                <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                    <el-dropdown-item command="connectWeb3Wallet">连接Web3钱包</el-dropdown-item>
                </el-dropdown-menu>
            </el-dropdown>
        </div>
    </div>
</template>

<script>
import Web3 from 'web3';

export default {
    methods: {
        async handleDropdownCommand(command) {
            if (command === 'connectWeb3Wallet') {
                if (window.ethereum) {
                    try {
                        //请求用户授权连接到钱包
                        await window.ethereum.request({ method: 'eth_requestAccounts' });
                        console.log('Connected to Web3 wallet:', window.ethereum.request({method: 'eth_accounts'}));
                        //执行与智能合约的交互操作
                    } catch (error) {
                        // 连接被用户拒绝时的处理逻辑
                        console.error('User denied wallet connection:', error);
                    }
                } else {
                    // 如果未检测到Web3提供商时的处理逻辑
                    console.error('Web3 provider not detected. Please install MetaMask or use a Web3-enabled browser');
                }
                }else if (command === 'profiles') {
                    
                } 
        },
        handleMenu() {
            this.$store.commit('collapseMenu')
        }
    }
}
</script>

<style lang="less" scoped>
.header-container {
    padding: 0 20px;
    background-color: #333;
    height: 60px;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .text {
        color: #fff;
        font-size: 14px;
        margin-left: 10px;
    }

    .r-content {
        .user {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
    }
}
</style>