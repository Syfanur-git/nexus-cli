#!/bin/bash

echo "[INFO] Mencari dan menghentikan proses nexus-network..."

# Cari dan hentikan proses nexus-network yang sedang berjalan
pkill -9 nexus-network

echo "[INFO] Proses nexus-network dihentikan."