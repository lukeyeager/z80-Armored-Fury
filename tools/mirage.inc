; MirageOS Development Include File
;
; Ver. 1.0 - Last Updated: 07/15/00
; By Dan Englender and Jason Kovacs


;#define bcall(label) RST 28h \ .dw label
;#define bjump(label) call 50h \ .dw label
;#define errhandon(label) ld hl,label \ call 59h
;#define errhandoff() call 5Ch

;=================================;
;======== Ion Subroutines ========;
;=================================;

iversion			  .equ $4083
irandom			   .equ $4086
isprite			   .equ $4089
ilsprite			  .equ $408C
igetpix			   .equ $408F
ifastcopy			 .equ $4092
idetect			   .equ $4095
idecomp			   .equ $4098

;=================================;
;====== MirageOS Subroutines =====;
;=================================;

directin			  .equ $409B
sendbytetios		  .equ $409E
getbytetios		   .equ $40A1
version			   .equ $40A4
setvputs			  .equ $40A7
setpixel			  .equ $40AA
fastcopys			 .equ $40AD
delayb				.equ $40B0
multhe				.equ $40B3
multhl				.equ $40B6
quittoshell		   .equ $40B9
fastline			  .equ $40BC
pixelonhl			 .equ $40BF
pixeloff			  .equ $40C2
pixelxor			  .equ $40C5
pixeltest			 .equ $40C8
pixeloffhl			.equ $40CB
pixelxorhl			.equ $40DE
pixeltesthl		   .equ $40D1
fastlineb			 .equ $40D4
fastlinew			 .equ $40D7
fastlinex			 .equ $40DA
pointonc			  .equ $40DD
pointoffc			 .equ $40E0
pointxorc			 .equ $40E3
centertext			.equ $40E6
cphlbc				.equ $40E9
putsprite8			.equ $40EC
fastcopyb			 .equ $40EF
vputsc				.equ $40F2
scrolld7			  .equ $40F5
vnewline			  .equ $40F8
rand127			   .equ $40FB
disprle			   .equ $40FE
cphlde				.equ $4101
screentopic		   .equ $4104
fastlined			 .equ $4107
disprlel			  .equ $410A
getnextgoodprog	   .equ $410D
getprevgoodprog	   .equ $4110
getnext			   .equ $4113
getprev			   .equ $4116
compstrs			  .equ $4119
nextstr			   .equ $411C
getinfo			   .equ $411F
fastrectangle		 .equ $4122
gettext			   .equ $4125
gettextv			  .equ $4128
FastRectangle_Save	.equ $412B
vputa				 .equ $412E
runprog			   .equ $4131
isgoodprog			.equ $4134
existfold			 .equ $4137
delprog			   .equ $413A
filledrectangle	   .equ $413D
nextfolder			.equ $4140
delfolder			 .equ $4143
moveall			   .equ $4149
curfoldname		   .equ $4149
curfoldnamea		  .equ $414C
createfolder		  .equ $414F
compstrsn			 .equ $4152
folder_menu_start	 .equ $4155
options_screen		.equ $4158
put_folder_name_top   .equ $415B
general_key_routine   .equ $415E
find_num_good_progs   .equ $4161
put_scrollbar		 .equ $4164
invert_lines		  .equ $4167
invert_1_line		 .equ $416A
right_align_value	 .equ $416D
put_mirageos_header   .equ $4170
put_size_graphic	  .equ $4173
sendprog			  .equ $4176
hideprog			  .equ $4179
arcprog			   .equ $417C
filledrectangle_save  .equ $417F
getbytetiosw		  .equ $4182
vatswap			   .equ $4185
renameprog			.equ $4188
renamefolder		  .equ $418B
sysmain			   .equ $418E
setupint			  .equ $4191
move_gui_prog		 .equ $4194
largespritehl		 .equ $4197
Update_Scrollbar	  .equ $419A
Initial_Scrollbar	 .equ $419D
sortallfolds		  .equ $41A0
dofoldsort			.equ $41A3
getfoldsort		   .equ $41A6
setfoldsort		   .equ $41A9
Increase_Cur_Element  .equ $41AC
Decrease_Cur_Element  .equ $41AF
Increase_Max_Elements .equ $41B2
Decrease_Max_Elements .equ $41B5
Add_A_To_Cur_Element  .equ $41B8
Sub_A_From_Cur_Element .equ $41BB
Add_A_To_Max_Elements .equ $41BE
Sub_A_From_Max_Elements .equ $41C1
Skip_Forward_B_From_Top .equ $41C4
Get_Curgoodprog_Ptr   .equ $41C7
getchecksum		   .equ $41CA
freearc			   .equ $41CD
swapram			   .equ $41D0
hideall			   .equ $41D3

;=================================;
;====== MirageOS Ram Equates =====;
;=================================;

mlinebitmap		   .equ $FFFF-399
timer1				.equ $8a3a
timer1max			 .equ $8a3b
timer2				.equ $8a3c
timer2max			 .equ $8a3d
timer3				.equ $8a3e
custintaddr		   .equ $966F

saferam1			  .equ saveSScreen
saferam2			  .equ appBackUpScreen
saferam3			  .equ tempSwapArea

mirflags			  .equ $21
rightalign			.equ $07

numscrollpixels	   .equ cmdShadow+104
scrollbarcoords	   .equ cmdShadow+105
old_element		   .equ cmdShadow+107
cur_element		   .equ cmdShadow+109
old_max_elem		  .equ cmdShadow+111
max_elements		  .equ cmdShadow+113

; =================================
; ===== Various Other Equates =====
; =================================

gbuf				  .equ plotSScreen
LargeSprite		   .equ ilsprite
SmallSprite		   .equ isprite
FastCopy			  .equ ifastcopy


.end
