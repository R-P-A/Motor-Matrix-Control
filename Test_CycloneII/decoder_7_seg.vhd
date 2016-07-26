library ieee;
use ieee.std_logic_1164.all;

entity decoder_7_seg is
    port (
        number : in std_logic_vector(3 downto 0);
        decoded : out std_logic_vector(6 downto 0)
    );
end entity; -- decoder_7_seg

architecture structural of decoder_7_seg is

begin

    decoded <= "1000000" when number = "0000" else -- 0
               "1111001" when number = "0001" else -- 1
               "0100100" when number = "0010" else -- 2
               "0110000" when number = "0011" else -- 3
               "0011001" when number = "0100" else -- 4
               "0010010" when number = "0101" else -- 5
               "0000010" when number = "0110" else -- 6
               "1111000" when number = "0111" else -- 7
               "0000000" when number = "1000" else -- 8
               "0011000" when number = "1001" else -- 9
               "0001000" when number = "1010" else -- A
               "0000011" when number = "1011" else -- b
               "1000110" when number = "1100" else -- C
               "0100001" when number = "1101" else -- d
               "0000110" when number = "1110" else -- E
               "0001110" when number = "1111" else -- F
               "1111111";                     -- Desligado

end architecture; -- structural