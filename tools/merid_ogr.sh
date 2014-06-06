# ogr2ogr -t_srs epsg:2193 merid_nztm.shp nz-meridional-circuit-boundaries-nzgd2000.shp
# # Buffer by 10km, simplify with 2km ...
# ogr2ogr -t_srs epsg:4167 merid_buff.shp merid_nztm_buff10km_simp2km.shp
# ogrinfo -al merid_buff.shp > merid_buff.dump





