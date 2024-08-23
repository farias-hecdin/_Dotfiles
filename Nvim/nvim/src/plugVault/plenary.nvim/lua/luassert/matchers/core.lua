local a=require('luassert.assert')local b=require('luassert.state')local c=require('luassert.util')local d=require('say')local function e(f)return b.format_argument(f)or tostring(f)end;local function g(h,i,j)local k=i[1]return function(l)local m=l;for n,o in pairs(m)do for p,q in pairs(m)do if n~=p then if k and c.deepcompare(o,q,true)then return false else if o==q then return false end end end end end;return true end end;local function r(h,i,j)local j=(j or 1)+1;local s=i.n;a(s>1,d("assertion.internal.argtolittle",{"near",2,tostring(s)}),j)local t=tonumber(i[1])local u=tonumber(i[2])local v="number or object convertible to a number"a(t,d("assertion.internal.badargtype",{1,"near",v,e(i[1])}),j)a(u,d("assertion.internal.badargtype",{2,"near",v,e(i[2])}),j)return function(l)local w=tonumber(l)if not w then return false end;return w>=t-u and w<=t+u end end;local function x(h,i,j)local j=(j or 1)+1;local s=i.n;a(s>0,d("assertion.internal.argtolittle",{"matches",1,tostring(s)}),j)local y=i[1]local z=i[2]local A=i[3]a(type(y)=="string",d("assertion.internal.badargtype",{1,"matches","string",type(i[1])}),j)a(z==nil or tonumber(z),d("assertion.internal.badargtype",{2,"matches","number",type(i[2])}),j)return function(l)local B=type(l)local w=nil;if B=="string"or B=="number"or B=="table"and(getmetatable(l)or{}).__tostring then w=tostring(l)end;if not w then return false end;return w:find(y,z,A)~=nil end end;local function C(h,i,j)local j=(j or 1)+1;local s=i.n;a(s>0,d("assertion.internal.argtolittle",{"equals",1,tostring(s)}),j)return function(l)return l==i[1]end end;local function D(h,i,j)local j=(j or 1)+1;local s=i.n;a(s>0,d("assertion.internal.argtolittle",{"same",1,tostring(s)}),j)return function(l)if type(l)=='table'and type(i[1])=='table'then local E=c.deepcompare(l,i[1],true)return E end;return l==i[1]end end;local function F(h,i,j)local j=(j or 1)+1;local s=i.n;local G=type(i[1])local H=G=="table"or G=="function"or G=="thread"or G=="userdata"a(s>0,d("assertion.internal.argtolittle",{"ref",1,tostring(s)}),j)a(H,d("assertion.internal.badargtype",{1,"ref","object",G}),j)return function(l)return l==i[1]end end;local function I(h,i,j)return function(l)return l==true end end;local function J(h,i,j)return function(l)return l==false end end;local function K(h,i,j)return function(l)return l~=false and l~=nil end end;local function L(h,i,j)local M=K(h,i,j)return function(l)return not M(l)end end;local function N(h,i,j,O)return function(l)return type(l)==O end end;local function P(h,i,j)return N(h,i,j,"nil")end;local function Q(h,i,j)return N(h,i,j,"boolean")end;local function R(h,i,j)return N(h,i,j,"number")end;local function S(h,i,j)return N(h,i,j,"string")end;local function T(h,i,j)return N(h,i,j,"table")end;local function U(h,i,j)return N(h,i,j,"function")end;local function V(h,i,j)return N(h,i,j,"userdata")end;local function W(h,i,j)return N(h,i,j,"thread")end;a:register("matcher","true",I)a:register("matcher","false",J)a:register("matcher","nil",P)a:register("matcher","boolean",Q)a:register("matcher","number",R)a:register("matcher","string",S)a:register("matcher","table",T)a:register("matcher","function",U)a:register("matcher","userdata",V)a:register("matcher","thread",W)a:register("matcher","ref",F)a:register("matcher","same",D)a:register("matcher","matches",x)a:register("matcher","match",x)a:register("matcher","near",r)a:register("matcher","equals",C)a:register("matcher","equal",C)a:register("matcher","unique",g)a:register("matcher","truthy",K)a:register("matcher","falsy",L)