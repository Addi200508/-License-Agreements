import { ethers } from "https://cdn.jsdelivr.net/npm/ethers@5.7.2/dist/ethers.esm.min.js";

// Replace with your deployed contract address and ABI
const contractAddress = "0x81986A4708404Be6bfa857d6E8373685aADe3dEe";
const contractABI = [/* paste your ABI here */];

let contract;
let signer;

// Connect to MetaMask and initialize contract
async function connectWallet() {
    if (window.ethereum) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        signer = provider.getSigner();
        contract = new ethers.Contract(contractAddress, contractABI, signer);
        console.log("Wallet connected");
    } else {
        alert("Please install MetaMask");
    }
}

// Call: Create a new license
async function createLicense(licensee, terms) {
    const tx = await contract.createLicense(licensee, terms);
    await tx.wait();
    console.log("License created for:", licensee);
}

// Call: Update own license
async function updateOwnLicense(newTerms) {
    const tx = await contract.updateOwnLicense(newTerms);
    await tx.wait();
    console.log("License updated");
}

// Call: Approve a licensee (only licensor)
async function approveLicensee(licensee, approved) {
    const tx = await contract.approveLicenseeToUpdateOwnLicense(licensee, approved);
    await tx.wait();
    console.log(`Licensee ${licensee} approval status: ${approved}`);
}

// Call: Get all licensee addresses
async function getAllLicensees() {
    const addresses = await contract.getAllLicensees();
    console.log("All Licensees:", addresses);
    return addresses;
}

// Call: Check if license is active
async function isLicenseActive(licensee) {
    const active = await contract.isLicenseActive(licensee);
    console.log(`License active: ${active}`);
    return active;
}

// UI example (you can attach these to buttons in your HTML)
document.getElementById("connectWalletBtn").onclick = connectWallet;
document.getElementById("getLicenseesBtn").onclick = getAllLicensees;
// Similarly bind other buttons...

