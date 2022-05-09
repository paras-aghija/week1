#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom using PLONK below

cd ../contracts/circuits

mkdir Multiplier3Plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."


circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3Plonk
snarkjs r1cs info Multiplier3Plonk/Multiplier3.r1cs

node Multiplier3Plonk/Multiplier3_js/generate_witness.js Multiplier3Plonk/Multiplier3_js/Multiplier3.wasm Multiplier3Plonk/in.json witness.wtns
snarkjs wtns export json witness.wtns witness.json



snarkjs plonk setup Multiplier3Plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3Plonk/circuit_final.zkey
# snarkjs zkey contribute Multiplier3Plonk/circuit_0000.zkey Multiplier3Plonk/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Multiplier3Plonk/circuit_final.zkey Multiplier3Plonk/verification_key.json


snarkjs plonk prove Multiplier3Plonk/circuit_final.zkey witness.wtns proof.json public.json
snarkjs plonk verify Multiplier3Plonk/verification_key.json public.json proof.json

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3Plonk/circuit_final.zkey ../Multiplier3PlonkVerifier.sol

cd ../..