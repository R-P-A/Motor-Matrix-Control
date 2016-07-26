library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_teste_CycloneV is
    port (
        SW : in std_logic_vector (9 downto 0);
        KEY : in std_logic_vector(3 downto 0);
        CLOCK_50 : in std_logic;
        HEX0, HEX1, HEX2 ,HEX3 ,HEX4 ,HEX5: out std_logic_vector(6 downto 0) := (others => '1');
        LEDR : out std_logic_vector (9 downto 0)
    );
end entity ; -- FSM_teste_CycloneV

architecture structural of FSM_teste_CycloneV is

    constant dataWidth : natural := 32;
    signal command_data, next_command_data, readdata : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
    signal interrupt, bistOut, reset, enable, acknowledge, enter : std_logic := '0';

    type states is (wait_command, save_command, wait_row, save_row, wait_col, save_col, wait_data, save_data);
    signal current_state, next_state : states;

    component MotorMatrixControl
        generic (
            rows : positive := 4;
            cols : positive := 4;
            dataWidth : positive := 32
        );
        port (
            clock, reset : in std_logic;
            enable : in std_logic;
            acknowledge : in std_logic;
            test : in std_logic;
            bistIn : in std_logic;
            readwrite : in std_logic_vector(1 downto 0);
            writedata : in std_logic_vector(dataWidth-1 downto 0);
            readdata : out std_logic_vector(dataWidth-1 downto 0);
            interrupt : out std_logic;
            bistOut : out std_logic;
			motors_out : out std_logic_vector(9 downto 0)
        );
    end component;

begin

	reset <= not(KEY(0));
	enable <= not(KEY(1));
	acknowledge <= not(KEY(2));
	enter <= not(KEY(3));
	
    topo : MotorMatrixControl
        generic map (
            rows => 2,
            cols => 5,
            dataWidth => dataWidth
        )
        port map (
            clock => CLOCK_50,
            reset => reset,
            enable => enable,
            acknowledge => acknowledge,
            test => '0',
            bistIn => '0',
            readwrite => SW(9 downto 8),
            writedata => command_data,
            readdata => readdata,
            interrupt => interrupt,
            bistOut => bistOut,
			motors_out => LEDR
        );

    -- FSM para pegar writedata
    memory_element : 
        process(CLOCK_50, reset)
        begin
            if (reset = '1') then
                current_state <= wait_command;
            elsif (rising_edge(CLOCK_50)) then
                current_state <= next_state;
                command_data <= next_command_data;
            end if;
        end process;

    next_state_logic : 
        process(current_state, enter)
        begin
            case current_state is
                when wait_command =>
                    if (enter = '1') then
                        next_state <= save_command;
                    else
                        next_state <= wait_command;
                    end if;

                when save_command =>
                    if (enter = '0') then
                        next_state <= wait_row;
                    else
                        next_state <= save_command;
                    end if;

                when wait_row =>
                    if (enter = '1') then
                        next_state <= save_row;
                    else
                        next_state <= wait_row;
                    end if;

                when save_row =>
                    if (enter = '0') then
                        next_state <= wait_col;
                    else
                        next_state <= save_row;
                    end if;

                when wait_col =>
                    if (enter = '1') then
                        next_state <= save_col;
                    else
                        next_state <= wait_col;
                    end if;

                when save_col =>
                    if (enter = '0') then
                        next_state <= wait_data;
                    else
                        next_state <= save_col;
                    end if;

                when wait_data =>
                    if (enter = '1') then
                        next_state <= save_data;
                    else
                        next_state <= wait_data;
                    end if;

                when save_data =>
                    if (enter = '0') then
                        next_state <= wait_command;
                    else
                        next_state <= save_data;
                    end if;

            end case;
        end process;

    output_logic : 
        process(current_state, SW)
        begin
            HEX0 <= "1111111";
            next_command_data <= command_data;
            case current_state is

                when wait_command =>
                    HEX0 <= "1000000";

                when save_command =>
                    next_command_data(dataWidth-1 downto dataWidth-8) <= SW(7 downto 0);

                when wait_row =>
                    HEX0 <= "1111001";

                when save_row =>
                    next_command_data(dataWidth-9 downto dataWidth-16) <= SW(7 downto 0);

                when wait_col =>
                    HEX0 <= "0100100";

                when save_col =>
                    next_command_data(dataWidth-17 downto dataWidth-24) <= SW(7 downto 0);

                when wait_data =>
                    HEX0 <= "0110000";

                when save_data =>
                    next_command_data(dataWidth-25 downto dataWidth-32) <= SW(7 downto 0);

            end case;
        end process;


end architecture ; -- structural