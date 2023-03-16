$ wait-for-it \
--service localhost:8181 \
--service localhost:9090 \
-- echo "[wait for it] weatherservice and toposervice are running!"