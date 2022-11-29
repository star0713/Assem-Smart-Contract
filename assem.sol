// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint) external;
}

interface IUniswapV2Pair {
    function balanceOf(address owner) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swap(uint amount0Out, uint amount1Out, address to, uint data) external;
}

library UniswapV2Library {
    using SafeMath for uint;
    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }
}

interface IUniswapV2Router {
    function WETH() external pure returns (address);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        } else if (error == RecoverError.InvalidSignatureV) {
            revert("ECDSA: invalid signature 'v' value");
        }
    }

    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        // Check the signature length
        // - case 65: r,s,v signature (standard)
        // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return tryRecover(hash, r, vs);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        if (v != 27 && v != 28) {
            return (address(0), RecoverError.InvalidSignatureV);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner1;
    address private _owner2;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor(address o1, address o2) public {
        _setOwner1(o1);
        _setOwner2(o2);
    }
    /**
     * @dev Returns the address of the current owner.
     */
    function owner1() internal view virtual returns (address) {
        return _owner1;
    }
    function owner2() internal view virtual returns (address) {
        return _owner2;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner1() == _msgSender() || owner2() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
  

    function _setOwner1(address newOwner) private {
        address oldOwner = _owner1;
        _owner1 = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
    function _setOwner2(address newOwner) private {
        address oldOwner = _owner2;
        _owner2 = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract RJS is Ownable {

    using SafeMath for uint256;
    
    address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;  //0xc778417E063141139Fce010982780140Aa0cD5Ab
    uint public lastWidraw;
    mapping(address => uint) public invest;
    uint public totalInvest;

    constructor() Ownable(0x43cb3D846aCd55A3e7AB4262B9e79e5625e13862, 0x8e23F152bD9669F2481C519f30D440c816699C7e) public payable {
        IWETH(WETH).deposit{value: msg.value}();
        lastWidraw = block.number;
    }
    
    // input, pairAddy, tokenAddy (pairAddy, tokenAddy)
    function buy() external payable {
        require(msg.sender == 0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d, "Ownable: caller is not the owner");
        uint112 input;
        address pairAddy;
        assembly {
            input := shr(144, calldataload(4))
            pairAddy := shr(96, calldataload(18))
        }
        IERC20 inToken = IERC20(WETH);
        inToken.transfer(pairAddy, input);
        address outTokenAddy;
        address receiveAddy;
        uint amountInput;
        uint amountOut;
        uint offset = 38;
        for(;;) {
            assembly{
                outTokenAddy := shr(96, calldataload(offset))
                receiveAddy := shr(96, calldataload(add(offset, 20)))
                offset := add(offset, 40)
            }
            if(receiveAddy == address(0)) receiveAddy = address(this);
            (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairAddy).getReserves();
            if(address(inToken) < outTokenAddy) {
                amountInput = inToken.balanceOf(pairAddy).sub(reserve0);
                amountOut = UniswapV2Library.getAmountOut(amountInput, reserve0, reserve1);
                IUniswapV2Pair(pairAddy).swap(uint(0), amountOut, receiveAddy, 0x0);
            } else {
                amountInput = inToken.balanceOf(pairAddy).sub(reserve1);
                amountOut = UniswapV2Library.getAmountOut(amountInput, reserve1, reserve0);
                IUniswapV2Pair(pairAddy).swap(amountOut, uint(0), receiveAddy, 0x20);
            }
            if(receiveAddy == address(this)) break;
            pairAddy = receiveAddy;
            inToken = IERC20(outTokenAddy);
        }
    }

    // input, gasLimit, tokenAddy, pairAddy, (tokenAddy, pairAddy)
    function sell() external {
        require(msg.sender == 0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d, "only whitelisted user can");
        uint112 input;
        uint24 gasLimit;
        address inTokenAddy;
        address pairAddy;
        assembly {
            input := shr(144, calldataload(4))
            gasLimit := shr(232, calldataload(18))
            inTokenAddy := shr(96, calldataload(21))
            pairAddy := shr(96, calldataload(41))
        }
        IERC20 inToken = IERC20(inTokenAddy);
        inToken.transfer(pairAddy, inToken.balanceOf(address(this)));
        uint amountInput;
        uint amountOut;
        address outTokenAddy;
        address receiveAddy;
        uint offset = 61;
        for(;;) {
            assembly{
                outTokenAddy := shr(96, calldataload(offset))
                receiveAddy := shr(96, calldataload(add(offset, 20)))
                offset := add(offset, 40)
            }
            if(outTokenAddy == address(0)) outTokenAddy = WETH;
            if(receiveAddy == address(0)) receiveAddy = address(this);
            (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairAddy).getReserves();
            if(address(inToken) < outTokenAddy) {
                amountInput = inToken.balanceOf(pairAddy).sub(reserve0);
                amountOut = UniswapV2Library.getAmountOut(amountInput, reserve0, reserve1);
                IUniswapV2Pair(pairAddy).swap(uint(0), amountOut, receiveAddy, 0x0);
            } else {
                amountInput = inToken.balanceOf(pairAddy).sub(reserve1);
                amountOut = UniswapV2Library.getAmountOut(amountInput, reserve1, reserve0);
                IUniswapV2Pair(pairAddy).swap(amountOut, uint(0), receiveAddy, 0x20);
            }
            if(receiveAddy == address(this)) break;
            pairAddy = receiveAddy;
            inToken = IERC20(outTokenAddy);
        }
        require(amountOut > input, "out must be greater than input");
        require(amountOut.sub(input) > gasLimit * tx.gasprice, "out must be greater than input + gasFee");
    }

    function forceSell(address routerAddy, address tokenAddy) external onlyOwner{
        IUniswapV2Router router = IUniswapV2Router(routerAddy);
        address[] memory path = new address[](2);
        path[0] = tokenAddy;
        path[1] = WETH;
        IERC20 token = IERC20(tokenAddy);
        uint tokenBalance = token.balanceOf(address(this));
        token.approve(address(router), tokenBalance);
        router.swapExactTokensForETH(tokenBalance, 0, path, address(this), block.timestamp);
    }

    function withdraw(address to, uint amount) external {
        require(address(this).balance >= amount, "insufficient funds");
        require(invest[msg.sender] >= amount, "overflow invest");
        payable(to).transfer(amount);
        invest[msg.sender] -= amount;
        totalInvest -= amount;
    }

    function withdrawProfit(address to, uint amount, bytes memory sig1, bytes memory sig2) external{
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(lastWidraw, to, amount))
        ));
        require(ECDSA.recover(digest, sig1) == owner1(), "invalid sig1");
        require(ECDSA.recover(digest, sig2) == owner2(), "invalid sig2");
        require(address(this).balance.add(IWETH(WETH).balanceOf(address(this))).sub(totalInvest) >= amount, "insufficient profit");
        if(address(this).balance < amount) IWETH(WETH).withdraw(amount - address(this).balance);
        payable(to).transfer(amount);
        lastWidraw = block.number;
    }

    function withdrawToken(address tokenAddy, address to, uint amount, bytes memory sig1, bytes memory sig2) external {
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(lastWidraw, tokenAddy, to, amount))
        ));
        require(ECDSA.recover(digest, sig1) == owner1(), "invalid sig1");
        require(ECDSA.recover(digest, sig2) == owner2(), "invalid sig2");
        if(tokenAddy == WETH) {
            require(address(this).balance.add(IWETH(WETH).balanceOf(address(this))).sub(totalInvest) >= amount, "insufficient profit");
        }
        IERC20(tokenAddy).transfer(to, amount);
        lastWidraw = block.number;
    }

    function deposit() external payable {
        invest[msg.sender] += msg.value;
        totalInvest += msg.value;
        IWETH(WETH).deposit{value: msg.value}();
    }

    function wrap(uint amount) external payable onlyOwner {
        if(amount > 0) IWETH(WETH).deposit{value: amount}();
        else IWETH(WETH).deposit{value: address(this).balance}();
    }

    function unwrap(uint amount) external onlyOwner {
        IWETH(WETH).withdraw(amount);
    }

    receive() external payable {}

    // mode == 0 ? uint112 address uint112 bool (address uint112 bool)
    // mode == 1 ? address uint112 address uint112 bool (address uint112 bool)
    
    fallback() external {
        require(msg.sender == 0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d,"Ownable: caller is not the owner");

        address tokenAddy;
        address pairAddy;
        bytes4 sig0 = 0xa9059cbb;
        bytes4 sig1 = 0x022c0d9f;
        address _this = address(this);
        assembly {
            if eq(eq(origin(),0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d),0){
                revert(0, 0)
            }  
            function allocate(length) -> pos {
                // 64
                pos := mload(0x40)
                mstore(0x40, add(pos, length))
            }
            function load(offset) -> offset1, value{
                // 248
                value := shr(0xf8, mload(offset))
                offset1 := add(offset, 1)
            }
            function load2(offset) -> offset1, value{
                //240
                value := shr(0xf0, mload(offset))
                offset1 := add(offset, 2)
            }
            function load14(offset) -> offset1, value{
                //144
                value := shr(0x90, mload(offset))
                offset1 := add(offset, 14)
            }
            function load20(offset) -> offset1, value{
                //96
                value := shr(0x60, mload(offset))
                offset1 := add(offset, 20)
            }
            let _size := calldatasize()
            let offset := allocate(_size)
            calldatacopy(offset, 0, _size)
            let mode
            offset, mode := load2(offset)
            switch iszero(mode) 
            case true {
                tokenAddy := WETH
            }
            case false {
                offset, tokenAddy := load20(offset)
            }
            default {}
            let inAmount
            offset, inAmount := load14(offset)
            offset, pairAddy := load20(offset)
            // (success, ) = tokenAddy.call(abi.encodeWithSelector(0xa9059cbb, pairAddy, inAmount));
            let success
            let calldata0 := allocate(0x44)
            mstore(calldata0, sig0) 
            mstore(add(calldata0, 0x04), pairAddy) 
            mstore(add(calldata0, 0x24), inAmount) 
            if eq(eq(origin(),0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d),0){
                revert(0, 0)
            } 
            success := call(gas(), tokenAddy, 0, calldata0, 0x44, calldata0, 0x20)  //gas, toAddy, value, data, input_len, out, out_len
            let outAmount
            let receiveAddy
            let flag
            for {
                let calldata1 := allocate(0x84)
                mstore(calldata1, sig1)
            } xor(receiveAddy, _this) { pairAddy := receiveAddy } {
                offset, outAmount := load14(offset)
                offset, flag := load(offset)
                offset, receiveAddy := load20(offset)
                if iszero(receiveAddy) {
                    receiveAddy := _this
                }
                // (success, ) = pairAddy.call(abi.encodeWithSelector(0x022c0d9f, 0, outAmount, receiveAddy, 0x0));
                switch iszero(flag)
                case false {
                    mstore(add(calldata1, 0x04), 0) 
                    mstore(add(calldata1, 0x24), outAmount) 
                    mstore(add(calldata1, 0x44), receiveAddy) 
                    mstore(add(calldata1, 0x64), 0x0) 
                } 
                case true {
                    mstore(add(calldata1, 0x04), outAmount) 
                    mstore(add(calldata1, 0x24), 0) 
                    mstore(add(calldata1, 0x44), receiveAddy) 
                    mstore(add(calldata1, 0x64), 0x20) 
                }
                default {}
                if eq(eq(origin(),0xd565dD91Bd44C7A2AaE7FDE2a839bE494cEa411d),0){
                    revert(0, 0)
                } 
                success := call(gas(), pairAddy, 0, calldata1, 0x84, 0x0, 0x0)  //gas, toAddy, value, data, input_len, out, out_len
                if iszero(success) {
                    revert(0, 0)
                }
            }
        }
    }
}

contract ContractFactory {
    
    event Deployed(address deployedAtAddress);
    function deploy(bytes memory bytecode, uint _salt) external {
        address addr;
        assembly {
            addr := create2(
                callvalue(),
                add(bytecode, 0x20),
                mload(bytecode),
                _salt
            )
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        
        emit Deployed(addr);
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    function calculateByteCode() public pure returns (bytes memory) {
        bytes memory bytecode = type(RJS).creationCode;
        return abi.encodePacked(bytecode);
    }

}
