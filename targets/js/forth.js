// JavaScript version of inner interpreter.

var data_stack = new Array(100);
var return_stack = new Array(100);
var forth_sp;
var forth_rp;
var input = [];

function forth_enter (ip, xt)
{
  return_stack[--forth_rp] = ip;
  ip = xt + 3;
  return ip;
}

function forth_exit (ip, xt)
{
  ip = return_stack[forth_rp++];
  return ip;
}

function forth_lit (ip, xt)
{
  data_stack[--forth_sp] = dictionary[ip++];
  return ip;
}

function forth_emit (ip, xt)
{
  var c = data_stack[forth_sp++];
  var s;
  if (c == 13)
    s = "<br>";
  else
    s = "&#" + c + ";";
  document.getElementById("output").innerHTML += s;
}

function forth_type (ip, xt)
{
  var string = data_stack[forth_sp++];
  document.getElementById("output").innerHTML += string;
  return ip;
}

function forth_bye (ip, xt)
{
  throw "bye";
  return ip;
}

function forth_fetch (ip, xt)
{
  var x = dictionary[data_stack[forth_sp++]];
  data_stack[--forth_sp] = x;
  return ip;
}

function forth_store (ip, xt)
{
  var addr = data_stack[forth_sp++];
  dictionary[addr] = data_stack[forth_sp++];
  return ip;
}

function forth_plus (ip, xt)
{
  var n = data_stack[forth_sp++];
  data_stack[forth_sp] += n;
  return ip;
}

function forth_tor (ip, xt)
{
  return_stack[--forth_rp] = data_stack[forth_sp++];
  return ip;
}

function forth_rfrom (ip, xt)
{
  data_stack[--forth_rp] = return_stack[forth_sp++];
  return ip;
}

var dictionary =
  [0,

   "warm",	//1 name
   0,		//2 link
   forth_enter,	//3 code
   13,		//4 lit
   "lbForth",   //5
   22,		//6 type
   9,		//7 quit
   19,		//8 bye

   "quit",	//9 name
   1,		//10 link
   forth_enter,	//11 code
   16,		//12 exit

   "lit",	//13 name
   9,		//14 link
   forth_lit,	//15 code

   "exit",	//16 name
   13,		//17 link
   forth_exit,	//18 code

   "bye",	//19 name
   16,		//20 link
   forth_bye,	//21 code

   "type",	//22 name
   19,		//23 link
   forth_type]	//24 code

function cold ()
{
  var ip = 4;
  forth_sp = 100;
  forth_rp = 100;

  try {
    for (;;) {
      var xt = dictionary[ip++];
      var fn = dictionary[xt + 2];
      ip = fn (ip, xt);
    }
  } catch(e) {}
}

function forth_key(x)
{
  console.log(x);
  input.push(x.charCode ? x.charCode : x.keyCode);
  data_stack[--forth_sp] = input.shift();
  forth_emit(0, 0);
}

cold();
