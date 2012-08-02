
;********************************************************
;
; Super Mario Clouds
;
; BEIGE 2002/3 - Cory Arcangel
;	
; http://www.post-data.org/beige/
; http://www.beigerecords.com/cory/
; http://del.icio.us/cory_arcangel/
;
; "you mess with the best, you die like the rest" - Anon
; "punks jump up to get beat down" - Brand Nubian
;
;********************************************************

asm

	.inesprg 2
	.ineschr 1
	.inesmir 1
	.inesmap 0
	
	.org $8000

	clouds_start:
	.dw clouds_start_addr
	clouds_start_addr:
	.incbin "clouds.hex"

start:

	sei
	cld

.vblank_clear1
	lda $2002
	bpl .vblank_clear1
	
.vblank_clear2
	lda $2002
	bpl .vblank_clear2

.vblank_clear3
	lda $2002
	bpl .vblank_clear3

	sei
	cld

.vblank_clear4
	lda $2002
	bpl .vblank_clear4
	
.vblank_clear5
	lda $2002
	bpl .vblank_clear5

.vblank_clear6
	lda $2002
	bpl .vblank_clear6

	
        lda #$00
        ldx #$00
.clear_out_ram
		sta $000,x
        sta $100,x
        sta $200,x
        sta $300,x
        sta $400,x
        sta $500,x
        sta $600,x
        sta $700,x
        inx
        bne .clear_out_ram
 
        lda #$00
        ldx #$00
.clear_out_sprites
		sta $2000,x
        sta $2100,x
        sta $2200,x
        sta $2300,x
        sta $2400,x
        sta $2500,x
        sta $2600,x
        sta $2700,x
        sta $2800,x
        sta $2900,x
        sta $2a00,x
        sta $2b00,x
        sta $2c00,x
        sta $2d00,x
        sta $2e00,x
        sta $2f00,x
        inx
        bne .clear_out_sprites
        
        ldx #$FF
        txs
 
	jsr vwait
	jsr vwait

;++++++++++++++++++++++++++++++++++++++++++++++++
;load palette
;++++++++++++++++++++++++++++++++++++++++++++++++

   lda   #$3F
   sta   $2006
   lda   #$00
   sta   $2006

	lda #$21 ;background [powder blue]
	sta $2007 
	lda #$30 ;cloud inside [white]
	sta $2007
	lda #$11 ; highlight [blue]
	sta $2007
	lda #$0d ;outline [black]
	sta $2007

;++++++++++++++++++++++++++++++++++++++++++++++++
;load name tables 
;++++++++++++++++++++++++++++++++++++++++++++++++


endasm
array addr 2
set songloadloop 0
asm

	ldx #0
	ldy #0
	
	lda #2
	sta songloadloop
load_outcast:
	lda clouds_start,y
 	sta addr,x
  	iny
 	inx
 	dec songloadloop
	bne load_outcast

	lda #$20
	sta $2006
	lda #$00
	sta $2006

nametables:
		
	ldx #$08
	ldy #$00
	
load_clouds:
	lda [addr],y
	sta $2007
	iny
	bne load_clouds
	txs
	ldx #$01
	inc addr,x
	tsx
	dex
	bne load_clouds

   lda   #$00
   sta   $2006
   sta   $2006       ;Reset PPU
   sta   $2005
   sta   $2005       ;Reset Scroll

;++++++++++++++++++++++++++++++++++++++++++++++++
;init graphic settings
;++++++++++++++++++++++++++++++++++++++++++++++++

 lda   #%10011100
 sta   $2000
 lda   #%00001010     
 sta   $2001

;++++++++++++++++++++++++++++++++++++++++++++++++
;set variables
;++++++++++++++++++++++++++++++++++++++++++++++++

endasm

 	set DELAYSCROLL 1
	set NTShow 0
	set SCROLL 0

asm

;++++++++++++++++++++++++++++++++++++++++++++++++
;loop forever....
;++++++++++++++++++++++++++++++++++++++++++++++++

main:

 jmp main

;++++++++++++++++++++++++++++++++++++++++++++++++
;vblankzzzzzz
;++++++++++++++++++++++++++++++++++++++++++++++++

vwait:
	lda $2002
	bpl vwait
vwait2:
	lda $2002
	bmi vwait2
 rts

;++++++++++++++++++++++++++++++++++++++++++++++++
;NMI Routine!!!!  Very important!!!!!
;++++++++++++++++++++++++++++++++++++++++++++++++

nmi:

	dec DELAYSCROLL
	bne .end_no_scroll

	lda #$20
	sta DELAYSCROLL

	lda #$ff
	cmp $24 ;scroll
	beq .NT_adj
	jmp .end

.NT_adj:

	lda #$00
	cmp NTShow
	beq .Show_Zero

	lda #%10011100
	sta $2000
	lda #%00001010 
	sta $2001

	lda #$00
	sta NTShow

	jmp .end

.Show_Zero:
	lda #%10011101
	sta $2000
	lda #%00001010 
	sta $2001

	lda #$01
	sta NTShow

.end:

	inc $24 ;scroll 
	lda $24 ;scroll
	sta $2005
	lda #$00
	sta $2005

.end_no_scroll:


 	rti
 
 irq:

 rti

;++++++++++++++++++++++++++++++++++++++++++++++++
;Load Data Filez
;++++++++++++++++++++++++++++++++++++++++++++++++

	.bank 3
	.org $fffa
	.dw nmi		;//NMI
	.dw start	;//Reset
	.dw irq	;//BRK
	.bank 4
	.org $0000
	;//end of file

    .incbin "mario.chr"  ;gotta be 8192 bytes long

endasm