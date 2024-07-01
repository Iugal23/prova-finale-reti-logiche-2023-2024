-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_583 is
end project_tb_583;

architecture project_tb_arch_583 of project_tb_583 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 445;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (28,0,0,0,202,0,47,0,232,0,0,0,160,0,0,0,0,0,153,0,136,0,143,0,154,0,47,0,27,0,55,0,65,0,65,0,120,0,11,0,248,0,170,0,53,0,32,0,234,0,65,0,147,0,0,0,121,0,177,0,242,0,174,0,0,0,237,0,95,0,0,0,95,0,208,0,0,0,130,0,0,0,221,0,233,0,59,0,33,0,0,0,78,0,170,0,55,0,114,0,131,0,0,0,0,0,235,0,158,0,33,0,17,0,0,0,0,0,137,0,130,0,236,0,0,0,0,0,209,0,20,0,82,0,207,0,122,0,12,0,216,0,65,0,145,0,51,0,166,0,82,0,43,0,75,0,221,0,0,0,0,0,0,0,51,0,125,0,46,0,41,0,226,0,111,0,106,0,0,0,84,0,9,0,39,0,124,0,184,0,0,0,28,0,0,0,18,0,182,0,122,0,30,0,0,0,0,0,170,0,0,0,156,0,94,0,87,0,0,0,91,0,246,0,135,0,27,0,0,0,170,0,228,0,0,0,0,0,12,0,93,0,142,0,73,0,177,0,253,0,0,0,76,0,87,0,171,0,65,0,189,0,254,0,28,0,98,0,0,0,0,0,143,0,52,0,70,0,6,0,166,0,192,0,0,0,101,0,126,0,169,0,0,0,193,0,0,0,26,0,0,0,246,0,110,0,104,0,252,0,136,0,237,0,21,0,0,0,0,0,212,0,0,0,234,0,244,0,173,0,50,0,124,0,111,0,253,0,0,0,123,0,0,0,0,0,0,0,164,0,7,0,0,0,63,0,124,0,52,0,123,0,255,0,0,0,247,0,0,0,15,0,58,0,150,0,253,0,135,0,129,0,222,0,146,0,52,0,0,0,66,0,0,0,125,0,0,0,55,0,152,0,132,0,74,0,247,0,152,0,0,0,0,0,83,0,60,0,0,0,201,0,244,0,172,0,165,0,242,0,19,0,85,0,160,0,123,0,137,0,116,0,140,0,130,0,102,0,194,0,162,0,58,0,179,0,49,0,0,0,0,0,0,0,125,0,206,0,98,0,76,0,0,0,58,0,127,0,128,0,189,0,0,0,0,0,15,0,93,0,124,0,0,0,127,0,177,0,140,0,124,0,75,0,234,0,110,0,247,0,255,0,0,0,29,0,0,0,65,0,208,0,0,0,0,0,161,0,0,0,232,0,109,0,68,0,0,0,48,0,80,0,153,0,194,0,85,0,0,0,0,0,85,0,79,0,84,0,44,0,37,0,144,0,242,0,61,0,0,0,16,0,75,0,83,0,14,0,14,0,226,0,97,0,192,0,41,0,29,0,0,0,0,0,176,0,0,0,144,0,97,0,49,0,80,0,109,0,164,0,126,0,43,0,172,0,6,0,212,0,63,0,0,0,66,0,151,0,10,0,122,0,72,0,231,0,0,0,216,0,31,0,178,0,43,0,154,0,0,0,66,0,138,0,197,0,72,0,151,0,0,0,92,0,213,0,78,0,176,0,121,0,0,0,0,0,159,0,0,0,0,0,7,0,121,0,0,0,234,0,240,0,197,0,117,0,54,0,0,0,95,0,194,0,143,0,237,0,69,0,29,0,251,0,254,0,154,0,99,0,0,0,233,0,119,0,171,0,228,0,208,0,0,0,34,0,216,0,246,0,191,0,226,0,195,0,0,0,137,0,0,0,174,0,209,0,0,0,216,0,21,0,146,0,172,0,127,0,88,0,188,0,28,0,111,0,65,0,37,0,235,0,0,0,17,0,101,0,127,0,180,0,153,0,122,0,23,0,243,0,193,0,102,0,242,0,27,0,187,0,2,0,52,0,22,0,167,0,0,0,0,0,91,0,116,0,172,0,148,0,144,0,243,0,0,0,226,0,204,0,24,0,187,0,62,0,107,0,14,0,0,0,0,0,95,0,83,0,116,0,46,0,72,0,138,0,118,0,0,0,0,0,141,0,170,0,0,0,0,0,107,0,159,0,191,0,110,0,204,0);
signal scenario_full  : scenario_type := (28,31,28,30,202,31,47,31,232,31,232,30,160,31,160,30,160,29,153,31,136,31,143,31,154,31,47,31,27,31,55,31,65,31,65,31,120,31,11,31,248,31,170,31,53,31,32,31,234,31,65,31,147,31,147,30,121,31,177,31,242,31,174,31,174,30,237,31,95,31,95,30,95,31,208,31,208,30,130,31,130,30,221,31,233,31,59,31,33,31,33,30,78,31,170,31,55,31,114,31,131,31,131,30,131,29,235,31,158,31,33,31,17,31,17,30,17,29,137,31,130,31,236,31,236,30,236,29,209,31,20,31,82,31,207,31,122,31,12,31,216,31,65,31,145,31,51,31,166,31,82,31,43,31,75,31,221,31,221,30,221,29,221,28,51,31,125,31,46,31,41,31,226,31,111,31,106,31,106,30,84,31,9,31,39,31,124,31,184,31,184,30,28,31,28,30,18,31,182,31,122,31,30,31,30,30,30,29,170,31,170,30,156,31,94,31,87,31,87,30,91,31,246,31,135,31,27,31,27,30,170,31,228,31,228,30,228,29,12,31,93,31,142,31,73,31,177,31,253,31,253,30,76,31,87,31,171,31,65,31,189,31,254,31,28,31,98,31,98,30,98,29,143,31,52,31,70,31,6,31,166,31,192,31,192,30,101,31,126,31,169,31,169,30,193,31,193,30,26,31,26,30,246,31,110,31,104,31,252,31,136,31,237,31,21,31,21,30,21,29,212,31,212,30,234,31,244,31,173,31,50,31,124,31,111,31,253,31,253,30,123,31,123,30,123,29,123,28,164,31,7,31,7,30,63,31,124,31,52,31,123,31,255,31,255,30,247,31,247,30,15,31,58,31,150,31,253,31,135,31,129,31,222,31,146,31,52,31,52,30,66,31,66,30,125,31,125,30,55,31,152,31,132,31,74,31,247,31,152,31,152,30,152,29,83,31,60,31,60,30,201,31,244,31,172,31,165,31,242,31,19,31,85,31,160,31,123,31,137,31,116,31,140,31,130,31,102,31,194,31,162,31,58,31,179,31,49,31,49,30,49,29,49,28,125,31,206,31,98,31,76,31,76,30,58,31,127,31,128,31,189,31,189,30,189,29,15,31,93,31,124,31,124,30,127,31,177,31,140,31,124,31,75,31,234,31,110,31,247,31,255,31,255,30,29,31,29,30,65,31,208,31,208,30,208,29,161,31,161,30,232,31,109,31,68,31,68,30,48,31,80,31,153,31,194,31,85,31,85,30,85,29,85,31,79,31,84,31,44,31,37,31,144,31,242,31,61,31,61,30,16,31,75,31,83,31,14,31,14,31,226,31,97,31,192,31,41,31,29,31,29,30,29,29,176,31,176,30,144,31,97,31,49,31,80,31,109,31,164,31,126,31,43,31,172,31,6,31,212,31,63,31,63,30,66,31,151,31,10,31,122,31,72,31,231,31,231,30,216,31,31,31,178,31,43,31,154,31,154,30,66,31,138,31,197,31,72,31,151,31,151,30,92,31,213,31,78,31,176,31,121,31,121,30,121,29,159,31,159,30,159,29,7,31,121,31,121,30,234,31,240,31,197,31,117,31,54,31,54,30,95,31,194,31,143,31,237,31,69,31,29,31,251,31,254,31,154,31,99,31,99,30,233,31,119,31,171,31,228,31,208,31,208,30,34,31,216,31,246,31,191,31,226,31,195,31,195,30,137,31,137,30,174,31,209,31,209,30,216,31,21,31,146,31,172,31,127,31,88,31,188,31,28,31,111,31,65,31,37,31,235,31,235,30,17,31,101,31,127,31,180,31,153,31,122,31,23,31,243,31,193,31,102,31,242,31,27,31,187,31,2,31,52,31,22,31,167,31,167,30,167,29,91,31,116,31,172,31,148,31,144,31,243,31,243,30,226,31,204,31,24,31,187,31,62,31,107,31,14,31,14,30,14,29,95,31,83,31,116,31,46,31,72,31,138,31,118,31,118,30,118,29,141,31,170,31,170,30,170,29,107,31,159,31,191,31,110,31,204,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
