; compute regional-mean climatological surface albedo and temperature in 1980-1999 and 2080-2099 over northern hemisphere land mass (>30N) in 17 CMIP3 models
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

 tas_current_regional = new((/12,17/),double)
 surface_albedo_current_regional = new((/12,17/),double)
 tas_future_regional = new((/12,17/),double)
 surface_albedo_future_regional = new((/12,17/),double)
 
 model_names = (/"mri_cgcm2_3_2a/run1/","cnrm_cm3/run1/","giss_model_e_r/run1/","iap_fgoals1_0_g/run1/","cccma_cgcm3_1/run1/","csiro_mk3_0/run2/","ncar_pcm1/run3/","ukmo_hadcm3/run1/","mpi_echam5/run1/","ukmo_hadgem1/run1/","miroc3_2_medres/run1/","ncar_ccsm3_0/run5/","miub_echo_g/run1/","ipsl_cm4/run1/","gfdl_cm2_0/run1/","gfdl_cm2_1/run1/","inmcm3_0/run1/"/)
new_id = (/11,4,1,5,8,12,3,14,15,2,16,13,10,0,6,7,9/)
 print(model_names(new_id))
 model_names_1 = (/"mri_cgcm2_3_2a/run1/","cnrm_cm3/run1/","giss_model_e_r/run1/","iap_fgoals1_0_g/run1/","cccma_cgcm3_1/run1/","csiro_mk3_0/run1/","ncar_pcm1/run3/","ukmo_hadcm3/run1/","mpi_echam5/run1/","ukmo_hadgem1/run1/","miroc3_2_medres/run1/","ncar_ccsm3_0/run5/","miub_echo_g/run1/","ipsl_cm4/run1/","gfdl_cm2_0/run1/","gfdl_cm2_1/run1/","inmcm3_0/run1/"/)
;hadgem1 ends at 2199 nov.
 start_year        = (/1851,1860,1880,1850,1850,1871,1890,1860,1860,1860,1850,1870,1860,1860,1861,1861,1871/)
 end_year          = (/2000,1999,2003,1999,2000,2000,1999,1999,2000,1999,2000,1999,2000,1999,2000,2000,2000/)
 start_year_1      = (/2001,2000,2004,2000,2001,2001,2000,2000,2001,2000,2001,2000,2001,2000,2001,2001,2001/)
 length1           = end_year-1980+1
 length2           = 2099-start_year_1+1

 do model_no = 0,16;
  print(model_names(model_no))
; 20th
  file_rsds_hist   = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/20c3m/atm/mo/rsds/" + model_names(model_no) + "rsds*.nc")
  file_rsus_hist   = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/20c3m/atm/mo/rsus/" + model_names(model_no) + "rsus*.nc")
  file_tas_hist    = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/20c3m/atm/mo/tas/" + model_names(model_no) + "/tas_*.nc")

  f_rsds_hist_0    = addfile(file_rsds_hist(0), "r")   ; note the "s" of addfile
  f_rsds_hist      = addfiles(file_rsds_hist, "r")   ; note the "s" of addfile
  f_rsus_hist      = addfiles(file_rsus_hist, "r")   ; note the "s" of addfile
  f_tas_hist       = addfiles(file_tas_hist, "r")   ; note the "s" of addfile
  lat              = f_rsds_hist_0->lat
  lon              = f_rsds_hist_0->lon

; A1B
  file_rsds_futu85 = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/sresa1b/atm/mo/rsds/" + model_names_1(model_no) + "rsds*.nc")
  file_rsus_futu85 = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/sresa1b/atm/mo/rsus/" + model_names_1(model_no) + "rsus*.nc")
  file_tas_futu85 = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/sresa1b/atm/mo/tas/" + model_names_1(model_no) + "tas*.nc")
  f_rsds_futu85    = addfiles(file_rsds_futu85, "r")   ; note the "s" of addfile
  f_rsus_futu85    = addfiles(file_rsus_futu85, "r")   ; note the "s" of addfile
  f_tas_futu85     = addfiles(file_tas_futu85, "r")   ; note the "s" of addfile

  rsds_4d = new((/12,length1(model_no)+length2(model_no),dimsizes(lat),dimsizes(lon)/),double)
  rsus_4d = new((/12,length1(model_no)+length2(model_no),dimsizes(lat),dimsizes(lon)/),double)
  tas_4d  = new((/12,length1(model_no)+length2(model_no),dimsizes(lat),dimsizes(lon)/),double)

  do i=0,length1(model_no)-1
    print ("model_no="+model_no +"    year="+i)
    do imonth=0,11
       rsds_4d(imonth,i,:,:) = f_rsds_hist[:]->rsds((1980-start_year(model_no)+i)*12+imonth,:,:);
       rsus_4d(imonth,i,:,:) = f_rsus_hist[:]->rsus((1980-start_year(model_no)+i)*12+imonth,:,:);
       tas_4d(imonth,i,:,:)  = f_tas_hist[:]->tas((1980-start_year(model_no)+i)*12+imonth,:,:);
    end do
  end do;
  delete(file_rsds_hist)
  delete(file_rsus_hist)
  delete(file_tas_hist)
  delete(f_rsds_hist_0)
  delete(f_rsds_hist)
  delete(f_rsus_hist)
  delete(f_tas_hist)

  do i=0,length2(model_no)-1
       ii = length1(model_no)+i
       print ("model_no="+model_no +"    year="+ii)
       do imonth=0,11
          if ((model_names(model_no).eq."ukmo_hadgem1/run1/" .or.model_names(model_no).eq."ukmo_hadcm3/run1/" ).and. i.ge.length2(model_no)-1 .and. imonth.eq.11)
             rsds_4d(imonth,i+length1(model_no),:,:) = f_rsds_futu85[:]->rsds(i*12+imonth-12,:,:);
             rsus_4d(imonth,i+length1(model_no),:,:) = f_rsus_futu85[:]->rsus(i*12+imonth-12,:,:);
             tas_4d(imonth,i+length1(model_no),:,:)  = f_tas_futu85[:]->tas(i*12+imonth-12,:,:)
          else
             rsds_4d(imonth,i+length1(model_no),:,:) = f_rsds_futu85[:]->rsds(i*12+imonth,:,:);
             rsus_4d(imonth,i+length1(model_no),:,:) = f_rsus_futu85[:]->rsus(i*12+imonth,:,:);
             tas_4d(imonth,i+length1(model_no),:,:)  = f_tas_futu85[:]->tas(i*12+imonth,:,:);
          end if
       end do
  end do
  delete(file_tas_futu85)
  delete(file_rsds_futu85)
  delete(file_rsus_futu85)
  delete(f_tas_futu85)
  delete(f_rsds_futu85)
  delete(f_rsus_futu85)

  file_sftlf = systemfunc("ls /Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/20c3m/land/fixed/sftlf/" + model_names_1(model_no) + "sftlf*")
  f_cl_sftlf_0   = addfile(file_sftlf(0), "r")   ; note the "s" of addfile
  sftlf = f_cl_sftlf_0->sftlf
  if (max(sftlf).lt.50)
      sftlf  = sftlf*100
  end if

  rsds_current = dim_avg_n(rsds_4d(:,1980-1980:1999-1980,:,:),1)
  rsus_current = dim_avg_n(rsus_4d(:,1980-1980:1999-1980,:,:),1)
  tas_current  = dim_avg_n(tas_4d(:,1980-1980:1999-1980,:,:),1)
  rsds_future  = dim_avg_n(rsds_4d(:,2080-1980:2099-1980,:,:),1)
  rsus_future  = dim_avg_n(rsus_4d(:,2080-1980:2099-1980,:,:),1)
  tas_future   = dim_avg_n(tas_4d(:,2080-1980:2099-1980,:,:),1)
  delete(rsds_4d)
  delete(rsus_4d)
  delete(tas_4d)

  sftlf_2d          = new((/12,dimsizes(lat),dimsizes(lon)/),double)
  do imonth =0,11
    sftlf_2d(imonth,:,:)         = sftlf
  end do
  delete(sftlf)

  lat_2d  = new((/12,dimsizes(lat),dimsizes(lon)/),double)
  lon_2d  = new((/12,dimsizes(lat),dimsizes(lon)/),double)
  do imonth=0,11
    do k=0,dimsizes(lon)-1
       lat_2d(imonth,:,k)=lat(:)
    end do
    do k=0,dimsizes(lat)-1
       lon_2d(imonth,k,:)=lon(:)
    end do
  end do

  weight = cos(3.14*lat_2d/180.)
  surface_albedo_current = new((/12,dimsizes(lat),dimsizes(lon)/),double)
  surface_albedo_future  = new((/12,dimsizes(lat),dimsizes(lon)/),double)
  do imonth=0,11
    do i=0,dimsizes(lat)-1
      do j=0,dimsizes(lon)-1
        if(rsds_current(imonth,i,j).ge.0.01)
         surface_albedo_current(imonth,i,j) = rsus_current(imonth,i,j)/rsds_current(imonth,i,j)
        else
         surface_albedo_current(imonth,i,j) = 0
        end if
        if(rsds_future(imonth,i,j).ge.0.01)
         surface_albedo_future(imonth,i,j)  = rsus_future(imonth,i,j)/rsds_future(imonth,i,j)
        else
         surface_albedo_future(imonth,i,j)  = 0
        end if
      end do
    end do
  end do

  weight = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, weight,-9999)
  surface_albedo_current = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, surface_albedo_current,-9999)
  tas_current  = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, tas_current,-9999)
  surface_albedo_future = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, surface_albedo_future,-9999)
  tas_future = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, tas_future,-9999)
  weight@_FillValue = -9999
  surface_albedo_current@_FillValue = -9999
  tas_current@_FillValue = -9999
  surface_albedo_future@_FillValue = -9999
  tas_future@_FillValue = -9999

  do imonth=0,11
       surface_albedo_current_regional(imonth,model_no) = sum(surface_albedo_current(imonth,:,:)*rsds_current(3,:,:)*weight(imonth,:,:))/sum(rsds_current(3,:,:)*weight(imonth,:,:))
       tas_current_regional(imonth,model_no) = sum(tas_current(imonth,:,:)*weight(imonth,:,:))/sum(weight(imonth,:,:))
       surface_albedo_future_regional(imonth,model_no) = sum(surface_albedo_future(imonth,:,:)*rsds_current(3,:,:)*weight(imonth,:,:))/sum(rsds_current(3,:,:)*weight(imonth,:,:))
       tas_future_regional(imonth,model_no) = sum(tas_future(imonth,:,:)*weight(imonth,:,:))/sum(weight(imonth,:,:))
  end do
  delete(rsds_current)
  delete(rsus_current)
  delete(tas_current)
  delete(rsds_future)
  delete(rsus_future)
  delete(tas_future)
  delete(sftlf_2d)
  delete(lat_2d)
  delete(lon_2d)
  delete(lat)
  delete(lon)
  delete(weight)
  delete(surface_albedo_current)
  delete(surface_albedo_future)
 end do;
 f_output = addfile("surface_albedo_temperature_in_current_future_climate_CMIP3.nc","c");  
 f_output->tas_current_regional            = tas_current_regional
 f_output->surface_albedo_current_regional = surface_albedo_current_regional
 f_output->tas_future_regional             = tas_future_regional
 f_output->surface_albedo_future_regional  = surface_albedo_future_regional
end
