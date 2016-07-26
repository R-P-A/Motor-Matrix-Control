library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_fsm_CycloneII is
    port (
        SW : in std_logic_vector (17 downto 0);
        KEY : in std_logic_vector(3 downto 0);
        CLOCK_50 : in std_logic;
        HEX0, HEX1, HEX2 ,HEX3 ,HEX4 ,HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0) := (others => '1');
        LEDR : out std_logic_vector(17 downto 0);
        LEDG : out std_logic_vector(8 downto 0);
        GPIO_1 : out std_logic_vector(35 downto 0)
    );
end entity ; -- top_fsm_CycloneII

architecture structural of top_fsm_CycloneII is

    constant dataWidth : natural := 32;
    signal current_command_data_row_col, next_command_data_row_col, readdata : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
    signal interrupt, bistOut, reset, enable, acknowledge, enter : std_logic := '0';
    signal readwrite : std_logic_vector(1 downto 0);
    signal motors_out : std_logic_vector(23 downto 0);

    type states is (wait_command_data, save_command_data, wait_row_col, save_row_col, wait_interrupt, send_acknowledge);
    signal current_state, next_state : states;

    signal current_state_number, current_command, current_row, current_col, current_data_high, current_data_low : std_logic_vector(3 downto 0);
    signal next_command, next_row, next_col, next_data_high, next_data_low : std_logic_vector(3 downto 0);
    signal decoded_current_state, decoded_command : std_logic_vector(6 downto 0);
    signal decoded_data_high, decoded_data_low, decoded_row, decoded_col : std_logic_vector(6 downto 0);
    
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
			motors_out : out std_logic_vector(23 downto 0)
        );
    end component;

    component decoder_7_seg is
        port (
            number : in std_logic_vector(3 downto 0);
            decoded : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    -- GPIO_1(35 downto 10) <= (others => '0'); Deixado comentado pois é necessário verificar quais pinos exatamente tem GND e VCC neles.
    -- GPIO_1(9 downto 0) <= motors_out;        O mesmo para esta parte.

    LEDR(17 downto 0) <= motors_out(17 downto 0);    -- Leds para simular os motores. Total de 6 linhas com 3 colunas cada.
    LEDG(7 downto 2) <= motors_out(23 downto 18);    -- Leds que mostram as duas primeiras linhas dos motores
    LEDG(1 downto 0) <= "00";

    readwrite <= '0' & SW(17);          -- Nunca lê e SW 17 para escrever

    HEX7 <= "0000110";                  -- E para representar Estado
    HEX6 <= decoded_current_state;      -- Coloca o estado atual decodificado

    HEX5 <= "1111111";                  -- Desligado
    HEX4 <= decoded_command;            -- Mostra o comando escolhido

    HEX3 <= decoded_row;                -- Mostra a linha escolhida
    HEX2 <= decoded_col;                -- Mostra a coluna escolhida
    HEX1 <= decoded_data_high;          -- Mostra o nibble mais significante do valor escolhido
    HEX0 <= decoded_data_low;           -- Mostra o nibble menos significante do valor escolhid
    
	reset <= not(KEY(0));               -- Negado para utilizar ativos em 1
	enter <= not(KEY(3));

    decoder_current_state : decoder_7_seg
        port map (
            number => current_state_number,
            decoded => decoded_current_state
        );

    decoder_command : decoder_7_seg
        port map (
            number => current_command,
            decoded => decoded_command
        );

    decoder_row : decoder_7_seg
        port map (
            number => current_row,
            decoded => decoded_row
        );

    decoder_col : decoder_7_seg
        port map (
            number => current_col,
            decoded => decoded_col
        );

    decoder_data_high : decoder_7_seg
        port map (
            number => current_data_high,
            decoded => decoded_data_high
        );

    decoder_data_low : decoder_7_seg
        port map (
            number => current_data_low,
            decoded => decoded_data_low
        );
	
    topo : MotorMatrixControl
        generic map (
            rows => 6,
            cols => 4,
            dataWidth => dataWidth
        )
        port map (
            clock => CLOCK_50,
            reset => reset,
            enable => enable,
            acknowledge => acknowledge,
            test => '0',
            bistIn => '0',
            readwrite => readwrite,
            writedata => current_command_data_row_col,
            readdata => readdata,
            interrupt => interrupt,
            bistOut => bistOut,
			motors_out => motors_out
        );
    
    -- FSM para pegar writedata
    memory_element : 
        process(CLOCK_50, reset)
        begin
            if (reset = '1') then
                current_state <= wait_command_data;
            elsif (rising_edge(CLOCK_50)) then
                current_state <= next_state;
                current_command_data_row_col <= next_command_data_row_col;
                current_command <= next_command;
                current_data_high <= next_data_high;
                current_data_low <= next_data_low;
                current_row <= next_row;
                current_col <= next_col;
            end if;
        end process;

    next_state_logic : 
        process(current_state, enter, interrupt)
        begin
            case current_state is
                when wait_command_data =>
                    if (enter = '1') then
                        next_state <= save_command_data;
                    else
                        next_state <= wait_command_data;
                    end if;

                when save_command_data =>
                    next_state <= wait_row_col;

                when wait_row_col =>
                    if (enter = '1') then
                        next_state <= save_row_col;
                    else
                        next_state <= wait_row_col;
                    end if;

                when save_row_col =>
                    next_state <= wait_interrupt;

                when wait_interrupt =>
                    if (interrupt = '1') then
                        next_state <= send_acknowledge;
                    else
                        next_state <= wait_interrupt;
                    end if;

                when send_acknowledge =>
                    next_state <= wait_command_data;

            end case;
        end process;

    output_logic : 
        process(current_state, SW, current_command, current_data_high, current_data_low, current_row, current_col, current_command_data_row_col)
        begin
            enable <= '0';
            acknowledge <= '0';
            LEDG(8) <= '0';
            next_command <= current_command;
            next_data_high <= current_data_high;
            next_data_low <= current_data_low;
            next_row <= current_row;
            next_col <= current_col;
            next_command_data_row_col <= current_command_data_row_col;
            case current_state is

                when wait_command_data =>
                    current_state_number <= "0000";
                    LEDG(8) <= '1';                          -- Indica que o sistema está pronto para receber novo comando e data
                    next_command <= SW(11 downto 8);         -- Mostra o comando nos displays
                    next_data_high <= SW(7 downto 4);        -- Mostra a potência em 2 nibbles nos displays
                    next_data_low <= SW(3 downto 0);         -- Segundo nibble da potência

                when save_command_data =>
                    current_state_number <= "0000";
                    next_command_data_row_col(dataWidth-1 downto dataWidth-8) <= SW(15 downto 8);   -- Salvo o comando
                    next_command_data_row_col(dataWidth-25 downto dataWidth-32) <= SW(7 downto 0);  -- Salva o dado

                when wait_row_col =>
                    current_state_number <= "0001";
                    next_row <= SW(11 downto 8);            -- Mostra a linha nos displays
                    next_col <= SW(3 downto 0);             -- Mostra a coluna nos displays

                when save_row_col =>
                    current_state_number <= "0001";
                    next_command_data_row_col(dataWidth-9 downto dataWidth-16) <= SW(15 downto 8);  -- Salva a linha
                    next_command_data_row_col(dataWidth-17 downto dataWidth-24) <= SW(7 downto 0);  -- Salva a coluna

                when wait_interrupt =>
                    current_state_number <= "0010";
                    enable <= '1';

                when send_acknowledge =>
                    current_state_number <= "0010";
                    acknowledge <= '1';

            end case;
        end process;


end architecture ; -- structural