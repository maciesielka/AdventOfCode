import Foundation

let input =
"""
405,945 -> 780,945
253,100 -> 954,801
518,300 -> 870,300
775,848 -> 20,848
586,671 -> 469,671
598,20 -> 900,20
51,975 -> 438,588
561,456 -> 67,456
353,135 -> 882,664
357,873 -> 407,873
480,247 -> 774,247
230,895 -> 230,709
590,738 -> 644,792
696,821 -> 696,198
501,461 -> 85,461
884,88 -> 884,922
140,780 -> 146,780
795,208 -> 273,208
256,185 -> 256,525
282,196 -> 282,85
701,133 -> 18,133
623,548 -> 623,573
734,895 -> 29,190
212,944 -> 934,944
948,504 -> 948,502
551,613 -> 551,27
62,54 -> 452,54
915,851 -> 915,290
924,843 -> 924,145
662,412 -> 422,172
465,87 -> 247,87
391,91 -> 326,91
267,572 -> 267,306
84,505 -> 594,505
453,383 -> 80,10
737,891 -> 784,891
599,339 -> 40,898
868,962 -> 31,125
153,661 -> 705,661
760,74 -> 339,495
972,72 -> 972,714
579,636 -> 169,226
365,218 -> 118,465
128,906 -> 767,267
733,165 -> 121,165
877,99 -> 105,871
176,917 -> 754,917
14,14 -> 981,981
170,958 -> 170,859
861,25 -> 96,790
128,143 -> 128,49
874,367 -> 334,367
373,434 -> 373,747
799,946 -> 439,586
17,923 -> 814,126
734,192 -> 734,632
267,280 -> 877,890
457,500 -> 457,26
525,679 -> 525,22
985,64 -> 85,964
312,411 -> 312,287
554,860 -> 600,860
209,163 -> 628,163
47,30 -> 917,900
870,948 -> 625,703
965,980 -> 53,68
874,631 -> 874,41
770,29 -> 770,882
950,988 -> 411,449
766,900 -> 904,900
77,23 -> 923,869
528,151 -> 528,96
785,468 -> 218,468
150,932 -> 333,932
908,846 -> 654,846
467,220 -> 588,220
303,437 -> 219,437
617,71 -> 899,353
116,311 -> 116,816
251,165 -> 316,165
126,897 -> 854,169
254,473 -> 818,473
817,265 -> 98,984
660,492 -> 558,492
562,117 -> 64,615
857,808 -> 857,311
39,641 -> 39,703
256,981 -> 988,249
923,175 -> 923,902
372,800 -> 503,800
48,339 -> 48,156
852,476 -> 852,397
874,190 -> 248,816
509,629 -> 503,629
246,17 -> 246,341
903,961 -> 568,626
405,740 -> 975,740
25,10 -> 982,967
761,287 -> 254,794
21,514 -> 21,111
772,350 -> 219,903
61,56 -> 275,270
608,197 -> 608,719
275,30 -> 275,145
712,601 -> 850,739
173,205 -> 173,667
93,644 -> 519,218
60,48 -> 911,899
21,975 -> 980,16
333,602 -> 634,602
899,374 -> 96,374
283,209 -> 963,889
22,20 -> 987,985
494,66 -> 70,490
836,876 -> 37,77
151,530 -> 472,851
459,531 -> 127,199
564,489 -> 315,240
193,341 -> 361,341
639,680 -> 511,680
855,217 -> 855,352
88,909 -> 920,77
948,318 -> 452,814
957,967 -> 957,297
741,172 -> 140,773
785,528 -> 467,528
135,658 -> 458,658
821,653 -> 821,633
932,137 -> 415,137
858,638 -> 858,696
494,495 -> 649,495
586,261 -> 478,369
18,680 -> 571,680
872,233 -> 872,823
715,935 -> 861,935
85,251 -> 206,372
42,972 -> 940,74
587,955 -> 66,955
393,466 -> 771,466
759,744 -> 36,21
694,90 -> 195,589
210,456 -> 857,456
656,476 -> 177,955
391,224 -> 902,735
929,802 -> 69,802
548,395 -> 892,395
576,838 -> 671,838
402,412 -> 899,412
567,601 -> 800,834
106,386 -> 907,386
848,349 -> 848,869
209,392 -> 785,392
28,105 -> 853,930
395,432 -> 795,432
582,570 -> 582,514
48,410 -> 211,573
248,617 -> 248,848
695,174 -> 941,420
215,651 -> 215,124
419,555 -> 112,555
358,975 -> 169,975
732,247 -> 732,573
132,983 -> 132,845
476,110 -> 476,196
852,437 -> 640,437
973,42 -> 109,906
954,797 -> 337,180
544,233 -> 134,233
412,150 -> 93,150
140,296 -> 140,407
485,875 -> 395,875
600,942 -> 931,942
235,677 -> 235,431
841,745 -> 148,52
265,803 -> 265,140
369,597 -> 230,736
788,745 -> 788,422
29,677 -> 75,677
590,669 -> 590,638
24,23 -> 24,438
279,476 -> 770,967
342,186 -> 57,186
50,49 -> 350,349
968,40 -> 28,980
101,101 -> 978,101
897,48 -> 27,918
595,232 -> 595,211
813,982 -> 335,504
624,41 -> 261,41
743,102 -> 530,102
234,814 -> 234,527
597,242 -> 492,242
36,84 -> 339,84
685,729 -> 398,729
506,733 -> 506,150
140,788 -> 816,112
775,816 -> 316,357
934,394 -> 301,394
635,983 -> 750,983
128,29 -> 128,712
347,348 -> 724,725
836,367 -> 390,367
60,718 -> 620,718
476,786 -> 476,870
318,490 -> 192,490
736,608 -> 736,926
14,79 -> 14,777
913,245 -> 344,814
876,775 -> 72,775
109,273 -> 109,416
376,64 -> 376,592
988,11 -> 22,977
544,602 -> 453,602
703,585 -> 703,602
147,976 -> 147,512
887,681 -> 657,451
36,913 -> 36,321
184,723 -> 252,655
523,905 -> 523,610
626,106 -> 653,106
703,211 -> 703,376
770,175 -> 770,765
387,628 -> 233,628
69,890 -> 877,82
608,751 -> 699,751
379,958 -> 572,958
556,555 -> 276,835
890,681 -> 234,25
937,792 -> 589,444
842,296 -> 547,296
488,638 -> 488,434
455,823 -> 484,823
488,610 -> 488,948
58,829 -> 931,829
453,481 -> 17,917
629,473 -> 629,53
584,512 -> 345,512
150,92 -> 283,92
663,692 -> 911,692
243,835 -> 243,600
28,26 -> 987,985
422,388 -> 385,388
534,798 -> 736,798
635,394 -> 799,394
155,895 -> 82,968
124,926 -> 968,82
142,431 -> 645,934
201,977 -> 601,977
169,322 -> 775,322
207,251 -> 652,696
989,975 -> 25,11
131,89 -> 131,864
981,989 -> 100,108
114,84 -> 114,434
98,713 -> 689,713
944,262 -> 548,262
481,568 -> 481,904
734,883 -> 734,605
716,687 -> 737,666
228,155 -> 702,155
847,675 -> 896,675
33,121 -> 33,865
58,211 -> 134,211
577,154 -> 659,236
415,958 -> 504,958
984,359 -> 55,359
215,22 -> 357,22
518,232 -> 406,232
264,950 -> 264,672
891,549 -> 891,45
785,328 -> 498,328
496,815 -> 664,815
138,55 -> 406,55
38,823 -> 38,383
467,184 -> 553,98
248,794 -> 864,178
415,561 -> 415,148
665,726 -> 665,236
767,777 -> 547,777
453,860 -> 453,196
23,645 -> 755,645
611,985 -> 559,985
33,978 -> 952,59
772,36 -> 889,36
626,521 -> 781,521
722,502 -> 722,30
978,946 -> 174,142
224,901 -> 655,470
924,142 -> 135,931
505,171 -> 365,171
303,888 -> 663,888
716,838 -> 255,377
494,390 -> 563,459
213,595 -> 516,595
264,436 -> 921,436
785,749 -> 785,78
50,50 -> 979,979
96,72 -> 96,564
647,278 -> 647,460
452,656 -> 452,487
686,145 -> 78,753
900,973 -> 728,973
545,137 -> 572,164
245,211 -> 726,211
550,606 -> 550,41
447,25 -> 447,197
941,581 -> 597,581
299,486 -> 484,486
789,67 -> 55,801
489,842 -> 489,228
716,452 -> 627,452
114,735 -> 329,950
810,157 -> 905,157
575,397 -> 568,404
414,221 -> 779,221
698,363 -> 745,363
976,498 -> 271,498
186,324 -> 519,324
105,777 -> 105,491
241,58 -> 241,102
126,883 -> 894,115
890,853 -> 731,694
760,713 -> 735,713
309,409 -> 61,161
365,263 -> 365,763
425,591 -> 623,591
224,233 -> 645,233
669,872 -> 669,594
112,773 -> 718,167
966,168 -> 966,223
982,527 -> 982,40
439,688 -> 668,688
537,685 -> 357,685
607,164 -> 127,164
192,894 -> 192,987
130,196 -> 130,311
847,987 -> 847,708
354,66 -> 354,260
660,441 -> 983,441
868,282 -> 868,962
915,272 -> 239,948
960,970 -> 26,36
595,837 -> 11,253
258,533 -> 258,209
664,802 -> 664,948
683,117 -> 448,117
961,104 -> 961,231
517,427 -> 134,427
233,451 -> 853,451
978,412 -> 978,496
222,71 -> 794,71
80,343 -> 604,867
209,104 -> 987,882
271,232 -> 711,232
754,329 -> 301,329
560,937 -> 716,937
653,194 -> 441,406
655,506 -> 655,671
599,336 -> 720,457
709,895 -> 468,895
538,432 -> 885,779
72,231 -> 471,231
694,131 -> 694,610
380,37 -> 380,673
46,921 -> 721,921
126,823 -> 343,823
771,617 -> 771,645
356,734 -> 356,406
710,504 -> 710,277
507,65 -> 510,65
292,913 -> 292,944
816,640 -> 913,640
101,132 -> 101,96
180,21 -> 743,584
548,231 -> 453,231
459,248 -> 498,248
567,637 -> 242,962
471,418 -> 471,601
104,822 -> 911,15
802,583 -> 459,583
330,681 -> 253,604
10,431 -> 209,431
220,776 -> 908,88
458,508 -> 458,697
87,803 -> 885,803
636,372 -> 324,372
891,528 -> 891,489
70,274 -> 70,268
255,587 -> 976,587
498,69 -> 498,250
783,838 -> 48,838
864,344 -> 968,240
323,734 -> 234,734
657,347 -> 657,410
661,682 -> 48,682
344,815 -> 344,132
137,878 -> 503,878
927,975 -> 982,920
753,964 -> 16,227
539,957 -> 539,48
314,651 -> 698,651
925,653 -> 271,653
861,518 -> 967,518
846,126 -> 41,931
103,409 -> 118,394
327,185 -> 874,732
716,930 -> 716,40
315,702 -> 246,702
130,377 -> 268,377
845,978 -> 39,172
147,977 -> 147,725
762,660 -> 606,660
871,186 -> 132,186
388,320 -> 388,584
302,410 -> 15,410
336,234 -> 336,673
331,208 -> 225,208
95,565 -> 315,785
843,563 -> 843,640
521,378 -> 118,378
963,17 -> 95,885
862,487 -> 974,487
874,402 -> 703,402
692,689 -> 692,237
947,635 -> 331,635
540,417 -> 737,220
770,161 -> 224,161
721,831 -> 721,424
10,411 -> 10,87
11,985 -> 986,10
465,972 -> 873,972
844,753 -> 676,753
181,27 -> 181,105
450,675 -> 333,558
578,286 -> 578,509
87,363 -> 274,363
892,119 -> 346,665
363,331 -> 363,22
508,424 -> 508,53
371,145 -> 669,145
109,761 -> 343,761
328,804 -> 328,570
411,741 -> 411,269
30,139 -> 915,139
912,736 -> 44,736
555,884 -> 672,884
433,427 -> 19,841
793,796 -> 505,508
737,554 -> 312,979
726,231 -> 568,231
954,479 -> 255,479
33,365 -> 262,365
677,608 -> 401,608
245,620 -> 828,37
295,274 -> 295,10
906,106 -> 906,263
682,719 -> 118,155
208,859 -> 634,859
739,103 -> 323,103
360,142 -> 13,489
131,553 -> 859,553
483,308 -> 483,124
776,720 -> 776,259
528,327 -> 651,450
423,223 -> 794,223
898,698 -> 898,315
488,824 -> 48,824
164,971 -> 773,362
975,850 -> 687,850
504,810 -> 795,810
562,281 -> 29,814
639,574 -> 684,529
417,800 -> 404,800
335,844 -> 335,907
17,41 -> 824,848
644,220 -> 470,220
304,944 -> 947,944
122,807 -> 122,257
308,553 -> 308,819
22,672 -> 22,386
837,675 -> 275,113
716,650 -> 482,650
212,350 -> 212,105
213,594 -> 213,119
431,375 -> 528,278
499,741 -> 58,741
600,291 -> 600,955
905,205 -> 326,205
584,152 -> 584,871
49,153 -> 883,987
818,822 -> 69,822
938,286 -> 938,832
75,380 -> 956,380
986,424 -> 450,960
736,470 -> 736,853
872,988 -> 371,988
102,203 -> 102,123
518,338 -> 518,360
819,263 -> 328,754
952,242 -> 178,242
"""

let sample =
"""
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""