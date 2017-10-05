; This script computes the strength of snow albedo feedback in the contexts of seasonal cycle and climate change for CMIP3 and 5 models
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
 f_output_AR5 = addfile("surface_albedo_temperature_in_current_future_climate_CMIP5.nc","r")
 feedback_climate_change_monthly_AR5 = (f_output_AR5->surface_albedo_future_regional - f_output_AR5->surface_albedo_current_regional) / (f_output_AR5->tas_future_regional - f_output_AR5->tas_current_regional)
 tas_climate_change_monthly_AR5      = f_output_AR5->tas_future_regional - f_output_AR5->tas_current_regional

 feedback_seasonal_cycle_AR5 = (f_output_AR5->surface_albedo_current_regional_April(3,:) - f_output_AR5->surface_albedo_current_regional_April(4,:))/(f_output_AR5->tas_current_regional(3,:) - f_output_AR5->tas_current_regional(4,:))
 tas_seasonal_cycle_AR5      = f_output_AR5->tas_current_regional(3,:) - f_output_AR5->tas_current_regional(4,:)

 f_output_AR4 = addfile("surface_albedo_temperature_in_current_future_climate_CMIP3.nc","r")
 feedback_climate_change_monthly_AR4 = (f_output_AR4->surface_albedo_future_regional - f_output_AR4->surface_albedo_current_regional) / (f_output_AR4->tas_future_regional - f_output_AR4->tas_current_regional)
 feedback_seasonal_cycle_AR4         = (f_output_AR4->surface_albedo_current_regional(3,:) - f_output_AR4->surface_albedo_current_regional(4,:))/(f_output_AR4->tas_current_regional(3,:) - f_output_AR4->tas_current_regional(4,:))

 new_id = (/11,4,1,5,8,12,3,14,15,2,16,13,10,0,6,7,9/)
 do i=0,11
   feedback_climate_change_monthly_AR4(i,:)=feedback_climate_change_monthly_AR4(i,new_id) ; reorder CMIP3 models
 end do
 feedback_seasonal_cycle_AR4(:)= feedback_seasonal_cycle_AR4(new_id)

 model_text_upper     = (/"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y"/)
 model_text_lower     = (/"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q"/)

 feedback_climate_change_AR4 = 100*feedback_climate_change_monthly_AR4(3,:)
 feedback_seasonal_cycle_AR4 = 100*feedback_seasonal_cycle_AR4
 feedback_climate_change_AR4!0="model_num_AR4"
 feedback_climate_change_AR4&model_num_AR4=ispan(1,17,1)
 feedback_climate_change_AR4@unit="%/K"
 feedback_seasonal_cycle_AR4!0="model_num_AR4"
 feedback_seasonal_cycle_AR4&model_num_AR4=ispan(1,17,1)
 feedback_seasonal_cycle_AR4@unit = "%/K"

 feedback_climate_change_AR5 = 100*feedback_climate_change_monthly_AR5(3,:)
 feedback_seasonal_cycle_AR5 = 100*feedback_seasonal_cycle
 feedback_climate_change_AR5!0="model_num_AR5"
 feedback_climate_change_AR5@unit="%/K"
 feedback_climate_change_AR5&model_num_AR5=ispan(1,25,1)
 feedback_seasonal_cycle_AR5!0="model_num_AR5"
 feedback_seasonal_cycle_AR5&model_num_AR5=ispan(1,25,1)
 feedback_seasonal_cycle_AR5@unit = "%/K"

 feedback_seasonal_cycle_observation = -0.87 
 feedback_seasonal_cycle_observation!0 = "observation_num" 
 feedback_seasonal_cycle_observation&observation_num=1 
 feedback_seasonal_cycle_observation@unit="%/K"
 feedback_seasonal_cycle_observation@confidence_internal="+/- 0.09"

 f_output_CMIP3_CMIP5 = addfile("snow_albedo_feedback.nc","c"); land cover greater than 70% 

 fAtt               = True            ; assign file attributes
 fAtt@title         = "Snow albedo feedback estimate (UCLA)"  
 fAtt@creation_date = systemfunc ("date")        
 fAtt@AR4_model_names = "CCSM3,CGCM3.1(T47),CNRM-CM3,CSIRO-Mk3.0,ECHAM5/MPI-OM,ECHO-G,FGOAlS-g1.0,GFDL-CM2.0,GFDL-CM2.1,GISS-ER,INM-CM3.0,ISPL-CM4,MIROC3.2(medres),MRI-CGCM2.3.2,PCM,UKMO-HadCM3,UKMO-HadGEM1: a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q"
 fAtt@AR5_model_names = "ACCESS1-0,BCC-CSM1.1,CCSM4,CNRM-CM5,CSIRO-Mk3.6,CanESM2,FGOALS-g2,FGOALS-s2,GFDL-CM3,GFDL-ESM2G,GFDL-ESM2M,GISS-E2-R,HadGEM2-CC,HadGEM2-ES,INM-CM4,IPSL-CM5A-LR,IPSL-CM5A-MR,IPSL-CM5B-LR,MIROC-ESM,MIROC-ESM-CHEM,MIROC5,MPI-ESM-LR,MPI-ESM-MR,MRI-CGCM3,NorESM1-M: A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y" 
 fileattdef( f_output_CMIP3_CMIP5, fAtt )            ; copy file attributes    
 f_output_CMIP3_CMIP5->feedback_climate_change_AR4 = feedback_climate_change_AR4 
 f_output_CMIP3_CMIP5->feedback_seasonal_cycle_AR4 = feedback_seasonal_cycle_AR4 
 f_output_CMIP3_CMIP5->feedback_climate_change_AR5 = feedback_climate_change_AR5 
 f_output_CMIP3_CMIP5->feedback_seasonal_cycle_AR5 = feedback_seasonal_cycle_AR5 
 f_output_CMIP3_CMIP5->feedback_seasonal_cycle_observation = feedback_seasonal_cycle_observation 

 print(escorc( feedback_climate_change_AR4, feedback_seasonal_cycle_AR4))
 print(escorc( feedback_climate_change_AR5, feedback_seasonal_cycle_AR5))
 feedback_climate_change_AR45 = new(42,double)
 feedback_seasonal_cycle_AR45 = new(42,double)
 feedback_climate_change_AR45(0:16) = feedback_climate_change_AR4
 feedback_climate_change_AR45(17+0:17+24) = feedback_climate_change_AR5
 feedback_seasonal_cycle_AR45(0:16) = feedback_seasonal_cycle_AR4
 feedback_seasonal_cycle_AR45(17+0:17+24) = feedback_seasonal_cycle_AR5
 print(escorc( feedback_climate_change_AR45, feedback_seasonal_cycle_AR45))
 rc = regline(feedback_seasonal_cycle_AR45, feedback_climate_change_AR45)
 print(rc)

;**********************************************
; plot 1
;**********************************************
 wks   = gsn_open_wks ("eps","snow_albedo_feedback_climate_change_seasonal_cycle")                 ; open workstation

 res                   = True                     ; plot mods desired
 res@xyMarkLineModes   = "Markers"                ; choose which have markers
 res@xyMarkers         =  16                      ; choose type of marker  
 res@xyMarkerColor     = "red"                    ; Marker color
 res@xyMarkerSizeF     = 0.015                     ; Marker size (default 0.01)
 res@trYMinF            = -1.7
 res@trYMaxF            = -0.28
 res@trXMinF            = -1.7
 res@trXMaxF            = -0.28
 res@gsnDraw              = False       ; Don't draw plote
 res@gsnFrame             = False       ; Don't advance frame
 res@tiXAxisString        = "Seasonal cycle (% K~S~-1~N~)"
 res@tiYAxisString        = "Climate change (% K~S~-1~N~)"
 res@xyDashPattern = 0
 res@xyLineThicknesses     = 2.
 res@gsnRightString        = ""
 res@gsnLeftString         = ""
 res@tiMainString          = "Snow albedo feedback strength"           ; add title
 res@tiMainFontHeightF = 0.020
 res@tmYLLabelFontHeightF = 0.020
 res@tmXBLabelFontHeightF = 0.020
 res@tiYAxisFontHeightF   = 0.020
 res@tiXAxisFontHeightF   = 0.020
 res@trYReverse           = True
 res@trXReverse           = True


 res@tmLabelAutoStride = True                     ; nice tick mark labels

 dummy_text = new(25,graphic)
 dummy_text_1 = new(25,graphic)
 dummy_text_2 = new(25,graphic)
 dummy_text_3 = new(25,graphic)
 print(escorc(feedback_2080_rcp85(3,:),feedback_seasonal_cycle))
 rc = regline(100*feedback_seasonal_cycle,100*feedback_2080_rcp85(3,:))
 print(rc)
 plot  = gsn_csm_xy(wks,-100*feedback_seasonal_cycle,-100*feedback_2080_rcp85(3,:),res)
 txres = True
 txres@txFontHeightF = 0.025                     ; font smaller. default big
 txres@txJust        = "CenterCenter"
 txres@txFontColor   = "red"                  ; text angle
;txres@txFont        = 22                       ; text angle
 txres@txFontThicknessF = 2
 dummy_text_5 = new(25,graphic)
 do i=0,24
   dummy_text_5(i) = gsn_add_text(wks,plot,model_text_upper(i),100*feedback_seasonal_cycle(i),100*feedback_2080_rcp85(3,i), txres)
 end do
 txres@txFontColor   = "blue"                  ; text angle
;txres@txFont        = 22                       ; text angle
 dummy_text_6 = new(25,graphic)
 do i=0,16
   dummy_text_6(i) = gsn_add_text(wks,plot,model_text_lower(i),feedback_seasonal_cycle_AR4(i),100*feedback_2100_AR4(3,i), txres)
 end do

 print(escorc(feedback_2100_AR4(3,:),feedback_seasonal_cycle_AR4))
 rc = regline(100*feedback_seasonal_cycle_AR4, 100*feedback_2100_AR4(3,:))
 print(rc)
 res@xyMarkerColor     = "blue"                    ; Marker color
 plot1  = gsn_csm_xy(wks,100*feedback_seasonal_cycle_AR4,100*feedback_2100_AR4(3,:),res)
;overlay(plot,plot1)
 print(max(100*feedback_seasonal_cycle_AR4))
 print(min(100*feedback_seasonal_cycle_AR4))
 print(max(100*feedback_2100_AR4(3,:)))
 print(min(100*feedback_2100_AR4(3,:)))

 xp    = new( (/2*2/), float )
 yp    = new( (/2*2/), float )
 xp    = (/-0.87-0.09,-0.87+0.09,-0.87+0.09,-0.87-0.09/)
 yp    = (/-4,-4,4,4/)
 gsres                   = True                        ; poly res
 gsres@tfPolyDrawOrder   = "Predraw"                   ; draw this first
 gsres@gsFillColor       = "gray"                 ; color chosen
 dummy = gsn_add_polygon (wks,plot,xp,yp,gsres)

 res_line = True
 res_line@gsLineDashPattern = 0
;res_line@gsLineColor  = index_color(i)
 res_line@gsLineThicknessF = 2.0                       ; thickness of lines
 res_line@gsLineDashPattern = 3
 dummy20=gsn_add_polyline(wks,plot,(/-4,4/),(/-4,4/),res_line)
 res_line@gsLineDashPattern = 1
 dummy40=gsn_add_polyline(wks,plot,(/-0.87,-0.87/),(/-4,4/),res_line)
;gsn_panel(wks,plot(0:1),(/2,1/),False)

 txres = True
 txres@txFontHeightF = 0.020                     ; font smaller. default big
 txres@txJust        = "CenterCenter"
 txres@txFontColor   = "black"                  ; text angle
 txres@txFont        = 22                       ; text angle
 y_dis=0.07
 dummy_text = gsn_add_text(wks,plot,"estimate",-0.87, -1.62, txres)
 dummy_text_1 = gsn_add_text(wks,plot,"based on",-0.87, -1.62+y_dis, txres)
 dummy_text_2 = gsn_add_text(wks,plot,"observed",-0.87, -1.62+2*y_dis, txres)
 dummy_text_3 = gsn_add_text(wks,plot,"seasonal",-0.87, -1.62+3*y_dis, txres)
 dummy_text_4 = gsn_add_text(wks,plot,"cycle",-0.87, -1.62+4*y_dis, txres)
 delete(txres)

 mres = True
 mres@gsMarkerSizeF = 15.
 mres@gsMarkerIndex = 16                        ; polymarker style
 mres@gsMarkerColor = "blue"                    ; polymarker color
 xx=-1.37
 yy=-0.48
 yy_d = -0.08
 mres@gsMarkerColor = "red"                    ; polymarker color

 txres = True
 txres@txFontHeightF = 0.016                     ; font smaller. default big
 txres@txJust        = "CenterLeft"
 txres@txFontColor   = "blue"                  ; text angle
 dummy30_text=gsn_add_text(wks,plot,"CMIP3", xx-0.05, yy, txres)
 txres@txFontColor   = "red"                  ; text angle
 dummy40_text=gsn_add_text(wks,plot,"CMIP5", xx-0.05, yy-yy_d, txres)
 draw(plot)
end 
