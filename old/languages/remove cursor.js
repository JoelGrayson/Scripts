#!/usr/bin/env node

const input=process.argv[2];
const output=input.replace('{{CURSOR}}', ''); //remove {{CURSOR}}

console.log(output); //to stdout
