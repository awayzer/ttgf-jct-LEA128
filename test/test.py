# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, with_timeout

# =========================
# RESET
# =========================
async def reset(dut):
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    for _ in range(5):
        await RisingEdge(dut.clk)


# =========================
# SEND BYTE
# =========================
async def send_byte(dut, byte):

    dut.ui_in.value = byte

    val = int(dut.uio_in.value)
    val |= 0b00000001
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    try:
        while dut.uio_out.value[7] == 0:
            await with_timeout(RisingEdge(dut.clk), 100, "us")
    except:
        assert False, "ACK timeout"

    val = int(dut.uio_in.value)
    val &= 0b11111110
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    while dut.uio_out.value[7] == 1:
        await RisingEdge(dut.clk)


# =========================
# RECEIVE BYTE
# =========================
async def receive_byte(dut):

    val = int(dut.uio_in.value)
    val |= 0b00000010
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    try:
        while dut.uio_out.value[6] == 0:
            await with_timeout(RisingEdge(dut.clk), 200, "us")
    except:
        assert False, "VALID timeout"

    data = int(dut.uo_out.value)

    val = int(dut.uio_in.value)
    val |= 0b00000100
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    val &= 0b11111011
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    val &= 0b11111101
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    return data


# =========================
# COMMON INPUTS
# =========================
key = [
    0x00, 0x1e, 0x2d, 0x3c,
    0x4b, 0x5a, 0x69, 0x78,
    0x87, 0x96, 0xa5, 0xb4,
    0xc3, 0xd2, 0xe1, 0xf0
]

plaintext = [
    0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f
]

cipher_expected = [
    0x9f, 0xc8, 0x4e, 0x35,
    0x28, 0xc6, 0xc6, 0x18,
    0x55, 0x32, 0xc7, 0xa7,
    0x04, 0x64, 0x8b, 0xfd
]


# =========================
# TEST 1 - ENCRYPT
# =========================
@cocotb.test()
async def test_encrypt(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    await reset(dut)

    dut._log.info("TEST 1: ENCRYPT")

    for b in key:
        await send_byte(dut, b)

    for b in plaintext:
        await send_byte(dut, b)

    # start encrypt
    val = int(dut.uio_in.value)
    val |= 0b00001000
    dut.uio_in.value = val
    await RisingEdge(dut.clk)
    val &= 0b11110111
    dut.uio_in.value = val

    for _ in range(300):
        await RisingEdge(dut.clk)

    val = int(dut.uio_in.value)
    val |= 0b00000010
    dut.uio_in.value = val

    received = []
    for i in range(16):
        received.append(await receive_byte(dut))

    for i in range(16):
        assert received[i] == cipher_expected[i]


# =========================
# TEST 2 - DECRYPT
# =========================
@cocotb.test()
async def test_decrypt(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    await reset(dut)

    dut._log.info("TEST 2: DECRYPT")

    # send key + ciphertext first
    for b in key:
        await send_byte(dut, b)

    for b in cipher_expected:
        await send_byte(dut, b)

    # start decrypt (uio_in[4])
    val = int(dut.uio_in.value)
    val |= 0b00010000
    dut.uio_in.value = val
    await RisingEdge(dut.clk)

    val &= 0b11101111
    dut.uio_in.value = val

    for _ in range(300):
        await RisingEdge(dut.clk)

    val = int(dut.uio_in.value)
    val |= 0b00000010
    dut.uio_in.value = val

    received = []
    for i in range(16):
        received.append(await receive_byte(dut))

    for i in range(16):
        assert received[i] == plaintext[i]

    dut._log.info("DECRYPT PASSED")
