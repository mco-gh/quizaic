export PROJECT_ID=780573810218
export REGION=us-central1
export INDEX_ENDPOINT_ID=5596993572449550336

gcloud ai index-endpoints --region "${REGION}" list

export ENDPOINT=265055794.us-central1-780573810218.vdb.vertexai.goog

curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer `gcloud auth print-access-token`"  ${ENDPOINT}/v1/projects/${PROJECT_ID}/locations/us-central1/indexEndpoints/3370566089086861312:findNeighbors -d '{deployed_index_id: "5596993572449550336", queries: [{datapoint: {datapoint_id: "0", feature_vector: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]}, neighbor_count: 5}]}'
