entity fa1bit is
    port(
        a, b, cin: in bit;
        result, cout: out bit
    );
end entity;
architecture structural of fa1bit is
begin
    result <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end architecture;
