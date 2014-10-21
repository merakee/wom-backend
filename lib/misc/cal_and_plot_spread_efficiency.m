- Execute MATLAB/Octave Script Online (GNU Octave 3.6.4) Help About Web Editors  Home
Command Line Arguments:	 		STDIN Input:	 	
Result
Download Files

  Multiple Files
main.minput.txt
Execute Script

20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
se=sc/tc;
end
end
function wf = cal_wf(tc,s_th,s_th_max)
if tc <= s_th
wf = 1.0;
elseif tc <= s_th_max
wf=2^(10*(-tc/s_th+1.0));
else
wf=0.0;
end
end
function si = cal_si(wf,ff,se)
si=1/(1+2^(-20*(wf*(ff-0.5) +(1-wf)*(se-0.5))));
end
tc_vec=[0:1:200];
fac_vec=[1:-.1:.1];
si_mat=[];
for fac=fac_vec
sc_vec=[];
ff_vec=[];
se_vec=[];
wf_vec=[];
si_vec=[];
for tc=tc_vec
sc=round(tc*fac);
sc_vec=[sc_vec;sc];
kc=tc-sc;
ff=cal_ff(tc,f_th,f_th_max);
ff_vec=[ff_vec;ff];
se=cal_se(sc,tc);
se_vec=[se_vec;se];
wf=cal_wf(tc,s_th,s_th_max);
wf_vec=[wf_vec;wf];
si=cal_si(wf,ff,se);
si_vec=[si_vec;si];
end
si_mat=[si_mat si_vec];
end
plot(tc_vec,si_mat,'r')
grid on
print -deps graph.eps
