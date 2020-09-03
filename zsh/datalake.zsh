#gls gs://brodmann_internal/datasources/datasource=fleet/stage=raw/datatype=video/setup=ffa757249bc7e679844c1408b3a01a44/video=ffa757249bc7e679844c1408b3a01a44/clip=na/
gls_fleet_carinfo() {
	gsutil cat  gs://brodmann_internal/datasources/datasource=fleet/stage=raw/datatype=fleet_capture_info/setup=${1}/video=${1}/clip=na/\*
}
gls_fleet_video() {
	gsutil ls gs://brodmann_internal/datasources/datasource=fleet/stage=raw/datatype=video/setup=${1}/video=${1}/clip=na
}
