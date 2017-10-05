; compute regional-mean climatological surface albedo and temperature in 1980-1999 and 2080-2099 over northern hemisphere land mass (>30N) in 25 CMIP5 models

  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
  tas_current_regional                  = new((/12,25/),double)
  surface_albedo_current_regional       = new((/12,25/),double)
  surface_albedo_current_regional_April = new((/12,25/),double)
  tas_future_regional                   = new((/12,25/),double)
  surface_albedo_future_regional        = new((/12,25/),double)
  partial_pla_partial_sur_mean          = new((/12,25/),double)
  partial_pla_partial_sur_sd            = new((/12,25/),double)
  feedback_strength_climate_change      = new((/12,25/),double)
  feedback_strength_seasonal_cycle      = new((/12,25/),double)
 
  diri            = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo"); where the data are
  start_year      = (/1850,1850,1850,1850,1850,1850,1900,1850,1860,1861,1896,1850,1885,1885,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850,1850/)
  end_year_rcp45  = (/2099,2199,2099,2199,2199,2199,2199,2199,2099,2099,2099,2199,2099,2199,2099,2199,2099,2099,2199,2099,2099,2199,2099,2099,2199/)
  end_year_rcp85  = (/2099,2199,2099,2199,2199,2099,2099,2099,2099,2099,2099,2199,2099,2199,2099,2199,2099,2099,2099,2099,2099,2199,2099,2099,2099/)
  length1         = 2005-1980+1
  length2         = 2099-2006+1

  f_kernal        = addfile("./CAM3_albedo_sw_kernel.nc","r"); Soden surface albedo kernel
  monkernel       = -100.*f_kernal->monkernel
  newlat          = f_kernal->lat
  newlon          = f_kernal->lon
  f_rsdt_AR4      = addfile("/Volumes/Time_Machine_Backups/IPCC_AR4_modeloutput/20c3m/atm/mo/rsdt/ncar_pcm1/run1/rsdt_A1.20C3M_1.PCM1.atmm.1890-01_cat_1999-12.nc","r")
  rsdt_4d_AR4     = new((/12,20,dimsizes(newlat),dimsizes(newlon)/),double)
  do i=0,20-1
    do imonth=0,11
      rsdt_4d_AR4(imonth,i,:,:) = f_rsdt_AR4->rsdt((1980-1890+i)*12+imonth,:,:);
    end do
  end do

  rsdt_AR4_month = dim_avg_n(rsdt_4d_AR4,1)
  delete(rsdt_4d_AR4)
  rsdt_AR4_month = where(rsdt_AR4_month.ge.0.01, rsdt_AR4_month, -9999)
  rsdt_AR4_month@_FillValue = -9999
  partial_pla_partial_sur            = monkernel/rsdt_AR4_month
  partial_pla_partial_sur@_FillValue = -9999
  partial_pla_partial_sur!0          = "month"
  partial_pla_partial_sur!1          = "lat"
  partial_pla_partial_sur!2          = "lon"
  partial_pla_partial_sur&month      = ispan(1,12,1)
  partial_pla_partial_sur&lat        = newlat
  partial_pla_partial_sur&lon        = newlon

  do model_no = 0,24;
;   historical
    file_rsds_hist   = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/hist/rsds_*.nc")
    file_rsus_hist   = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/hist/rsus_*.nc")
    file_tas_hist    = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/hist/tas_*.nc")
    file_rsdt_hist   = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/hist/rsdt_*.nc")
    f_rsds_hist_0    = addfile(file_rsds_hist(0), "r")   ; note the "s" of addfile
    f_rsds_hist      = addfiles(file_rsds_hist, "r")   ; note the "s" of addfile
    f_rsus_hist      = addfiles(file_rsus_hist, "r")   ; note the "s" of addfile
    f_tas_hist       = addfiles(file_tas_hist, "r")   ; note the "s" of addfile
    f_rsdt_hist      = addfiles(file_rsdt_hist, "r")   ; note the "s" of addfile
    lat              = f_rsds_hist_0->lat
    lon              = f_rsds_hist_0->lon

;   rcp8.5
    file_rsds_futu85 = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/rcp8.5/rsds_*.nc")
    file_rsus_futu85 = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/rcp8.5/rsus_*.nc")
    file_tas_futu85  = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/rcp8.5/tas_*.nc")
    file_rsdt_futu85 = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/rcp8.5/rsdt_*.nc")
    f_rsds_futu85    = addfiles(file_rsds_futu85, "r")   ; note the "s" of addfile
    f_rsus_futu85    = addfiles(file_rsus_futu85, "r")   ; note the "s" of addfile
    f_tas_futu85     = addfiles(file_tas_futu85, "r")   ; note the "s" of addfile
    f_rsdt_futu85    = addfiles(file_rsdt_futu85, "r")   ; note the "s" of addfile

    rsds_4d = new((/12,120,dimsizes(lat),dimsizes(lon)/),double)
    rsus_4d = new((/12,120,dimsizes(lat),dimsizes(lon)/),double)
    tas_4d  = new((/12,120,dimsizes(lat),dimsizes(lon)/),double)
    rsdt_4d = new((/12,120,dimsizes(lat),dimsizes(lon)/),double)

    do i=0,length1-1
      print ("model_no="+model_no +"    year="+i)
      do imonth=0,11
        if (diri(model_no).eq."HadGEM2-CC" .or. diri(model_no).eq."HadGEM2-ES")
           if(i.ge.length1-1 .and. imonth.ge.11)
              rsds_4d(imonth,i,:,:) = f_rsds_futu85[:]->rsds(0,:,:);
              rsus_4d(imonth,i,:,:) = f_rsus_futu85[:]->rsus(0,:,:);
              tas_4d(imonth,i,:,:)  = f_tas_futu85[:]->tas(0,:,:);
              rsdt_4d(imonth,i,:,:) = f_rsdt_futu85[:]->rsdt(0,:,:);
           else
              rsds_4d(imonth,i,:,:) = f_rsds_hist[:]->rsds((1980-start_year(model_no)+i)*12+imonth+1,:,:);
              rsus_4d(imonth,i,:,:) = f_rsus_hist[:]->rsus((1980-start_year(model_no)+i)*12+imonth+1,:,:);
              tas_4d(imonth,i,:,:)  = f_tas_hist[:]->tas((1980-start_year(model_no)+i)*12+imonth+1,:,:);
              rsdt_4d(imonth,i,:,:) = f_rsdt_hist[:]->rsdt((1980-start_year(model_no)+i)*12+imonth+1,:,:);
           end if
        else
              rsds_4d(imonth,i,:,:) = f_rsds_hist[:]->rsds((1980-start_year(model_no)+i)*12+imonth,:,:);
              rsus_4d(imonth,i,:,:) = f_rsus_hist[:]->rsus((1980-start_year(model_no)+i)*12+imonth,:,:);
              tas_4d(imonth,i,:,:)  = f_tas_hist[:]->tas((1980-start_year(model_no)+i)*12+imonth,:,:);
              rsdt_4d(imonth,i,:,:) = f_rsdt_hist[:]->rsdt((1980-start_year(model_no)+i)*12+imonth,:,:);

        end if
      end do
    end do;
    delete(file_rsds_hist)
    delete(file_rsdt_hist)
    delete(file_rsus_hist)
    delete(file_tas_hist)
    delete(f_rsds_hist_0)
    delete(f_rsds_hist)
    delete(f_rsdt_hist)
    delete(f_rsus_hist)
    delete(f_tas_hist)

    do i=0,length2-1
       ii = length1+i
       print ("model_no="+model_no +"    year="+ii)
       do imonth=0,11
          if (diri(model_no).eq."HadGEM2-CC" .or. diri(model_no).eq."HadGEM2-ES")
             rsds_4d(imonth,i+length1,:,:) = f_rsds_futu85[:]->rsds(i*12+imonth+1,:,:);
             rsus_4d(imonth,i+length1,:,:) = f_rsus_futu85[:]->rsus(i*12+imonth+1,:,:);
             tas_4d(imonth,i+length1,:,:)  = f_tas_futu85[:]->tas(i*12+imonth+1,:,:)
             rsdt_4d(imonth,i+length1,:,:) = f_rsdt_futu85[:]->rsdt(i*12+imonth+1,:,:);
          else
             rsds_4d(imonth,i+length1,:,:) = f_rsds_futu85[:]->rsds(i*12+imonth,:,:);
             rsus_4d(imonth,i+length1,:,:) = f_rsus_futu85[:]->rsus(i*12+imonth,:,:);
             tas_4d(imonth,i+length1,:,:)  = f_tas_futu85[:]->tas(i*12+imonth,:,:);
             rsdt_4d(imonth,i+length1,:,:) = f_rsdt_futu85[:]->rsdt(i*12+imonth,:,:);
          end if
       end do
    end do
    delete(file_tas_futu85)
    delete(file_rsds_futu85)
    delete(file_rsdt_futu85)
    delete(file_rsus_futu85)
    delete(f_tas_futu85)
    delete(f_rsds_futu85)
    delete(f_rsdt_futu85)
    delete(f_rsus_futu85)

    file_sftlf = systemfunc("ls /Volumes/Data_Server/CMIP5_modeloutput/mo/" + diri(model_no) + "/sftlf*")
    f_cl_sftlf_0   = addfile(file_sftlf(0), "r")   ; note the "s" of addfile
    sftlf = f_cl_sftlf_0->sftlf
    if (diri(model_no).eq."MIROC-ESM" .or. diri(model_no).eq."MIROC-ESM-CHEM")
       sftlf  = sftlf*100
    end if

    rsds_current = dim_avg_n(rsds_4d(:,1980-1980:1999-1980,:,:),1)
    rsus_current = dim_avg_n(rsus_4d(:,1980-1980:1999-1980,:,:),1)
    tas_current  = dim_avg_n(tas_4d(:,1980-1980:1999-1980,:,:),1)
    rsdt_current = dim_avg_n(rsdt_4d(:,1980-1980:1999-1980,:,:),1)
    rsds_future  = dim_avg_n(rsds_4d(:,2080-1980:2099-1980,:,:),1)
    rsus_future  = dim_avg_n(rsus_4d(:,2080-1980:2099-1980,:,:),1)
    tas_future   = dim_avg_n(tas_4d(:,2080-1980:2099-1980,:,:),1)
    delete(rsds_4d)
    delete(rsus_4d)
    delete(tas_4d)
    delete(rsdt_4d)

    lat_2d  = new((/12,dimsizes(lat),dimsizes(lon)/),double)
    lon_2d  = new((/12,dimsizes(lat),dimsizes(lon)/),double)
    do imonth=0,11
      do k=0,dimsizes(lon)-1
         lat_2d(imonth,:,k) = lat(:)
      end do
      do k=0,dimsizes(lat)-1
        lon_2d(imonth,k,:)  = lon(:)
      end do
    end do

    partial_pla_partial_sur_new    = new((/12,dimsizes(lat),dimsizes(lon)/),double)
    sftlf_2d                       = new((/12,dimsizes(lat),dimsizes(lon)/),double)
    do imonth =0,11
      partial_pla_partial_sur_new(imonth,:,:)    = linint2(newlon,newlat,partial_pla_partial_sur(imonth,:,:),True,lon,lat,0)
      sftlf_2d(imonth,:,:)                       = sftlf
    end do
    partial_pla_partial_sur_new!0          = "month"
    partial_pla_partial_sur_new!1          = "lat"
    partial_pla_partial_sur_new!2          = "lon"
    partial_pla_partial_sur_new&month      = ispan(1,12,1)
    partial_pla_partial_sur_new&lat        = lat
    partial_pla_partial_sur_new&lon        = lon
    partial_pla_partial_sur_new            = where(lat_2d.ge.30 .and. sftlf_2d.ge.65, partial_pla_partial_sur_new,-9999)
    partial_pla_partial_sur_new@_FillValue = -9999
    do imonth=0,11
      partial_pla_partial_sur_mean(imonth,model_no) = avg(ndtooned(partial_pla_partial_sur_new(imonth,:,:)))
      partial_pla_partial_sur_sd(imonth,model_no)   = stddev(ndtooned(partial_pla_partial_sur_new(imonth,:,:)))
    end do
    delete(sftlf)

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
 
    weight@_FillValue                 = -9999
    surface_albedo_current@_FillValue = -9999
    tas_current@_FillValue            = -9999
    surface_albedo_future@_FillValue  = -9999
    tas_future@_FillValue             = -9999

    do imonth=0,11
       surface_albedo_future_regional(imonth,model_no)        = sum(surface_albedo_future(imonth,:,:)*rsds_current(imonth,:,:)*weight(imonth,:,:))/sum(rsds_current(imonth,:,:)*weight(imonth,:,:))
       tas_future_regional(imonth,model_no)                   = sum(tas_future(imonth,:,:)*weight(imonth,:,:))/sum(weight(imonth,:,:))
       surface_albedo_current_regional(imonth,model_no)       = sum(surface_albedo_current(imonth,:,:)*rsds_current(imonth,:,:)*weight(imonth,:,:))/sum(rsds_current(imonth,:,:)*weight(imonth,:,:))
       surface_albedo_current_regional_April(imonth,model_no) = sum(surface_albedo_current(imonth,:,:)*rsds_current(3,:,:)*weight(imonth,:,:))/sum(rsds_current(3,:,:)*weight(imonth,:,:))
       tas_current_regional(imonth,model_no)                  = sum(tas_current(imonth,:,:)*weight(imonth,:,:))/sum(weight(imonth,:,:))

       feedback_strength_climate_change(imonth,model_no)      = sum((surface_albedo_future(imonth,:,:)-surface_albedo_current(imonth,:,:))*partial_pla_partial_sur_new(imonth,:,:)*rsdt_current(imonth,:,:)*weight(imonth,:,:))/sum((tas_future(imonth,:,:)-tas_current(imonth,:,:))*weight(imonth,:,:)) 
    end do
    do imonth=0,10
       feedback_strength_seasonal_cycle(imonth,model_no)      = sum((surface_albedo_current(imonth+1,:,:)-surface_albedo_current(imonth,:,:))*partial_pla_partial_sur_new(imonth,:,:)*rsdt_current(imonth,:,:)*weight(imonth,:,:))/sum((tas_current(imonth+1,:,:)-tas_current(imonth,:,:))*weight(imonth,:,:)) 
    end do
    feedback_strength_seasonal_cycle(11,model_no)             = sum((surface_albedo_current(0,:,:)-surface_albedo_current(11,:,:))*partial_pla_partial_sur_new(11,:,:)*rsdt_current(11,:,:)*weight(11,:,:))/sum((tas_current(0,:,:)-tas_current(11,:,:))*weight(11,:,:)) 
    delete(rsds_current)
    delete(rsdt_current)
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
    delete(partial_pla_partial_sur_new)
  end do;
  f_output = addfile("surface_albedo_temperature_in_current_future_climate_CMIP5.nc","c");  
  f_output->tas_current_regional                  = tas_current_regional
  f_output->surface_albedo_current_regional       = surface_albedo_current_regional
  f_output->surface_albedo_current_regional_April = surface_albedo_current_regional_April
  f_output->tas_future_regional                   = tas_future_regional
  f_output->surface_albedo_future_regional        = surface_albedo_future_regional
  f_output->partial_pla_partial_sur_mean          = partial_pla_partial_sur_mean
  f_output->partial_pla_partial_sur_sd            = partial_pla_partial_sur_sd
  f_output->feedback_strength_climate_change      = feedback_strength_climate_change
  f_output->feedback_strength_seasonal_cycle      = feedback_strength_seasonal_cycle
end
