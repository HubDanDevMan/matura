
getRandomString:

	call getRandNr
	; random nr is now ax
	shl ax, 1; multiply by 2 because the pointer is 2 bytes large
	mov esi, stringarray	; set edi to point to array base
	add esi, ax		; add stringpointer offset of array to esi
	ret



stringarray:
dw str1	
dw str2	
dw str3	
dw str4	
dw str5	
dw str6	
dw str7	
dw str8	
dw str9	
dw str10	
dw str11	
dw str12	
dw str13	
dw str14	
dw str15	
dw str16	
dw str17	
dw str18	
dw str19	
dw str20	
dw str21	
dw str22	
dw str23	
dw str24	
dw str25	
dw str26	
dw str27	
dw str28	
dw str29	
dw str30	
dw str31	
dw str32	
dw str33	
dw str34	
dw str35	
dw str36	
dw str37	
dw str38	
dw str39	
dw str40	
dw str41	
dw str42	
dw str43	
dw str44	
dw str45	
dw str46	
dw str47	
dw str48	
dw str49	
dw str50	
dw str51	
dw str52	
dw str53	
dw str54	
dw str55	
dw str56	
dw str57	
dw str58	
dw str59	
dw str60	
dw str61	
dw str62	
dw str63	
dw str64	
dw str65	
dw str66	
dw str67	
dw str68	
dw str69	
dw str70	
dw str71	
dw str72	
dw str73	
dw str74	
dw str75	
dw str76	
dw str77	
dw str78	
dw str79	
dw str80	
dw str81	
dw str82	
dw str83	
dw str84	
dw str85	
dw str86	
dw str87	
dw str88	
dw str89	
dw str90	
dw str91	
dw str92	
dw str93	
dw str94	
dw str95	
dw str96	
dw str97	
dw str98	
dw str99	
dw str100	
dw str101	
dw str102	
dw str103	
dw str104	
dw str105	
dw str106	
dw str107	
dw str108	
dw str109	
dw str110	
dw str111	
dw str112	
dw str113	
dw str114	
dw str115	
dw str116	
dw str117	
dw str118	
dw str119	
dw str120	
dw str121	
dw str122	
dw str123	
dw str124	
dw str125	


;	 _    _          _   _  _____ __  __          _   _ 
;	| |  | |   /\   | \ | |/ ____|  \/  |   /\   | \ | |
;	| |__| |  /  \  |  \| | |  __| \  / |  /  \  |  \| |
;	|  __  | / /\ \ | . ` | | |_ | |\/| | / /\ \ | . ` |
;	| |  | |/ ____ \| |\  | |__| | |  | |/ ____ \| |\  |
;	|_|  |_/_/    \_\_| \_|\_____|_|  |_/_/    \_\_| \_|
;	                                                    
;	                                                    
