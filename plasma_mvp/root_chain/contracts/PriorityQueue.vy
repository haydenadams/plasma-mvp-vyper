owner: address
heapList: uint256[int128]
currentSize: uint256

#@public
#def __init__():
#    self.owner = msg.sender    
#    self.heapList = [0] # correct syntax?
#    self.currentSize = 0

# Temporary solution for constructor, 
# look at https://github.com/ethereum/vyper/issues/773#issuecomment-383714363
@public
def setup() -> bool:
    self.owner = msg.sender
    self.heapList = [0]
    self.currentSize = 0
    return True

@public
def insert(_k: uint256):
    assert msg.sender == self.owner
    self.heapList[int128(self.currentSize)] = _k
    self.currentSize += 1
    self.percUp(self.currentSize)

@public
@constant
def minChild(_i: uint256) -> uint256:
    if i * 2 + 1 > self.currentSize:
        return i * 2
    else:
        if self.heapList[_i * 2] < self.heapList[i * 2 + 1]:
            return i * 2
        else:
            return i * 2 + 1

@public
@constant
def getMin() -> uint256:
    return self.heapList[1]

@public
def delMin() -> uint256:
    assert msg.sender == self.owner
    retVal: uint256 = self.heapList[1]
    self.heapList[1] = self.heapList[int128(self.currentSize)]
    self.heapList[int128(self.currentSize)] = 0

    self.currentSize -= 1
    self.percDown(1)
    
    return retVal

@private
def percUp(_i: uint256):
    j: uint256 = _i
    newVal: uint256 = self.heapList[int128(_i)]
    while newVal < self.heapList[int128(_i / 2)]:   # correct syntax?
        self.heapList[int128(_i)] = self.heapList[int128(_i / 2)]
        _i /= 2

    if _i != j:
        self.heapList[_i] = newVal


@private
def percDown(_i: uint256):
    j: uint256 = _i
    newVal: uint256 = self.heapList[int128(_i)]
    mc: uint256 = self.minChild(_i)
    while mc <= self.currentSize and newVal > self.heapList[int128(mc)]:    # correct syntax?
        self.heapList[int128(_i)] = self.heapList[int128(mc)]
        _i = mc
        mc = self.minChild(_i)

    if _i != j:
        self.heapList[int128(_i)] = newVal
