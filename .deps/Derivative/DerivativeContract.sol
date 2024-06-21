//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract DerivativeContract {
    //定义金融衍生品合约的数据结构
    struct Derivative {
        address seller; //卖方的地址
        address buyer; //买方的地址
        uint256 price; //价格
        uint256 expiration; //到期时间
        bool isClosed; //合约是否已关闭
    }

    //存储所有的金融衍生品合约
    mapping(uint256 => Derivative) public derivatives;
    //下一个金融衍生品合约的Id
    uint256 public nextDerivativeId;
    //存储用户的数字资产余额
    mapping(address => uint256) public balances;

    //数字资产充值时触发此事件
    event Deposit(address indexed user, uint256 amount);
    //在创建金融衍生品合约时触发此事件
    event NewDerivative(
        uint256 indexed nextDerivativeId,
        address indexed seller,
        address indexed buyer,
        uint256 price,
        uint256 expiration
    );
    //在关闭金融衍生品合约时触发此事件
    event DerivativeClosed(uint256 indexed derivativeId);
    //在修改金融衍生品合约时触发此事件
    event DerivativeUpdated(uint256 indexed derivativeId, uint256 newPrice);
    //在结算金融衍生品合约时触发此事件
    event DerivativeSettled(uint256 indexed derivativeId);

    //充值数字资产
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    //创建新的金融衍生品合约
    function createDerivative(
        address _buyer,
        uint256 _price,
        uint256 _expiration
    ) external {
        require(_buyer != address(0), "Invalid buyer address");
        require(_price > 0, "Price must be greater than 0");
        require(balances[msg.sender] >= _price, "Insufficient balance");
        

        derivatives[nextDerivativeId] = Derivative({
            seller: msg.sender,
            buyer: _buyer,
            price: _price,
            expiration: _expiration,
            isClosed: false
        });

        emit NewDerivative(
            nextDerivativeId,
            msg.sender,
            _buyer,
            _price,
            _expiration
        );
        nextDerivativeId++;
    }

    //关闭指定ID的金融衍生品合约
    //如果合约已关闭，则禁止新的交易或修改合约的其他状态。这有助于确保合约在特定状态下执行特定的逻辑。
    function closeDerivative(uint256 derivativeId) external {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");
        require(
            derivatives[derivativeId].seller == msg.sender ||
                derivatives[derivativeId].buyer == msg.sender
        );

        if (!derivatives[derivativeId].isClosed) {
            balances[msg.sender] += derivatives[derivativeId].price;
            emit Deposit(msg.sender, derivatives[derivativeId].price);
        }

        derivatives[derivativeId].isClosed = true;
        emit DerivativeClosed(derivativeId);
    }

    //判断指定ID的金融衍生品合约是否已经关闭
    function isDerivativeClosed(uint256 derivativeId)
        external
        view
        returns (bool)
    {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");

        return derivatives[derivativeId].isClosed;
    }

    //查询指定ID的金融衍生品到期时间
    function getDerivativeExpiration(uint256 derivativeId)
        external
        view
        returns (uint256)
    {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");

        return derivatives[derivativeId].expiration;
    }

    //检查指定金融衍生品合约是否已到期
    function isDerivativeExpired(uint256 derivativeId)
        external
        view
        returns (bool)
    {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");
        return block.timestamp >= derivatives[derivativeId].expiration;
    }

    //查询指定ID的金融衍生品合约信息
    function getDerivativeInfo(uint256 derivativeId)
        external
        view
        returns (
            address,
            address,
            uint256,
            uint256,
            bool
        )
    {
        Derivative memory derivative = derivatives[derivativeId];
        return (
            derivative.seller,
            derivative.buyer,
            derivative.price,
            derivative.expiration,
            derivative.isClosed
        );
    }

    //获取当前合约的总金融衍生品数量
    function getToralDerivatives() external view returns (uint256) {
        return nextDerivativeId;
    }

    //获取指定ID的金融衍生品合约的价格
    function getDerivativePrice(uint256 derivativeId)
        external
        view
        returns (uint256)
    {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");

        return derivatives[derivativeId].price;
    }

    //修改金融衍生品合约的价格
    function updateDerivativePrice(uint256 derivativeId, uint256 newPrice)
        external
    {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");
        require(derivatives[derivativeId].seller == msg.sender, "Unauthorized");

        balances[msg.sender] += newPrice - derivatives[derivativeId].price;
        derivatives[derivativeId].price = newPrice;
        emit DerivativeUpdated(derivativeId, newPrice);
    }

    //结算指定ID的金融衍生品合约
    function settleDerivative(uint256 derivativeId) external {
        require(derivativeId < nextDerivativeId, "Invalid derivative ID");
        require(
            this.isDerivativeExpired(derivativeId),
            "Derivative not expired yet"
        );
        require(
            derivatives[derivativeId].isClosed == false,
            "Derivative already closed"
        );

        balances[derivatives[derivativeId].seller] += derivatives[derivativeId]
            .price;
        balances[derivatives[derivativeId].buyer] -= derivatives[derivativeId]
            .price;

        derivatives[derivativeId].isClosed = true;
        emit DerivativeSettled(derivativeId);
    }

    // 提取指定账户的余额
    function withdrawBalance(address account) external {
        uint256 accountBalance = balances[account];
        require(accountBalance > 0, "Account balance is zero");

        balances[account] = 0; // 将账户余额置为零，避免重入攻击
        payable(account).transfer(accountBalance);
    }
}
