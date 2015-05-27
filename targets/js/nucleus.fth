\ -*- forth -*- Copyright 2015 Lars Brinkhoff

code cold \ cold ()
  var IP = warm_word + 19;
  var fn = function () { IP = step(IP, 0); };

  forth_sp = 100;
  forth_rp = 256;

  window.setInterval(function () { IP = step_code(IP, step_code); }, 1);
end-code

code step ( -- )
    var xt = dictionary[IP++];
    var s = "";
    var n = dictionary[xt];
    for (i = 1; i <= n; i++)
      s += String.fromCharCode(dictionary[xt+i]);
    console.log(s);
    var fn = dictionary[xt+18];
    IP = fn (IP, xt);
end-code

code enter ( R: -- ret )
    return_stack[--forth_rp] = IP;
    IP = xt + 19;
end-code

code exit ( R: ret -- )
    IP = return_stack[forth_rp++];
end-code

code dodoes ( -- addr ) ( R: -- ret )
    data_stack[--forth_sp] = xt + 19;
    return_stack[--forth_rp] = IP;
    IP = dictionary[xt + 17];
end-code

code 0branch ( x -- )
    if (!data_stack[forth_sp++])
      IP = dictionary[IP];
    else
      IP++;
end-code

code (literal) ( -- n )
    data_stack[--forth_sp] = dictionary[IP++];
end-code

code ! ( x addr -- )
    var addr = data_stack[forth_sp++];
    dictionary[addr] = data_stack[forth_sp++];
end-code

code @ ( addr -- x )
    var a = data_stack[forth_sp];
    var x = dictionary[a];
    if (a == 881)
      x = forth_sp;
    else if (a == 901)
      x = forth_rp;
    data_stack[forth_sp] = x;
end-code

code + ( x y -- x+y )
    var x = data_stack[forth_sp++];
    data_stack[forth_sp] += x;
end-code

code >r  ( x -- ) ( R: -- x )
    return_stack[--forth_rp] = data_stack[forth_sp++];
end-code

code r> ( -- x ) ( R: x -- )
    data_stack[--forth_sp] = return_stack[forth_rp++];
end-code

code nand ( x y -- ~(x&y) )
    var u1 = data_stack[forth_sp++];
    var u2 = data_stack[forth_sp++];
    data_stack[--forth_sp] = ~(u1 & u2);
end-code

code c! ( c addr -- )
    var addr = data_stack[forth_sp++];
    dictionary[addr] = data_stack[forth_sp++];
end-code

code c@ ( addr -- c )
    data_stack[forth_sp] = dictionary[data_stack[forth_sp]];
end-code

code emit ( c -- )
    var c = data_stack[forth_sp++];
    var s;
    if (c == 13)
      s = "<br>";
    else
      s = "&#" + c + ";";
    output += s;
end-code

code bye ( ... -- <no return> )
    throw "bye";
end-code

code close-file ( fileid -- ior )
    var fileid = data_stack[forth_sp++];
    data_stack[--forth_sp] = 0;
end-code

code open-file ( addr u mode -- fileid ior )
end-code

code read-file ( addr u1 fileid -- u2 ior )
end-code

code receive-key ( -- )
    var x = xt;
    console.log(x);
    input.push(x.charCode ? x.charCode : x.keyCode);
    data_stack[--forth_sp] = input.shift();
    emit_code(0, 0);
end-code

code (sliteral) ( ... )
    var n = dictionary[IP++]
    data_stack[--forth_sp] = IP;
    data_stack[--forth_sp] = n;
    IP += n;
end-code
