const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Contract deployed to " + waveContract.address);

  // Get contract balance
  let contractEther = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractEther));

  // Send two waves
  const waveTxn = await waveContract.wave("First message #1!");
  await waveTxn.wait();

  // const waveTxn2 = await waveContract.wave("Second message #2!");
  // await waveTxn2.wait();

  // get contract balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
