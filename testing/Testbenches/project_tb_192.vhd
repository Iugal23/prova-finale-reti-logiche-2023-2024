-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_192 is
end project_tb_192;

architecture project_tb_arch_192 of project_tb_192 is
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

constant SCENARIO_LENGTH : integer := 335;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,202,0,241,0,77,0,48,0,15,0,169,0,0,0,96,0,202,0,245,0,61,0,63,0,203,0,0,0,151,0,72,0,52,0,0,0,197,0,28,0,219,0,99,0,0,0,98,0,71,0,0,0,192,0,160,0,240,0,96,0,0,0,0,0,0,0,225,0,0,0,159,0,94,0,236,0,43,0,164,0,0,0,0,0,244,0,238,0,62,0,103,0,82,0,120,0,92,0,252,0,199,0,59,0,9,0,208,0,210,0,38,0,15,0,218,0,44,0,0,0,98,0,108,0,114,0,87,0,216,0,152,0,220,0,207,0,0,0,18,0,83,0,111,0,7,0,64,0,144,0,3,0,0,0,162,0,154,0,239,0,197,0,225,0,222,0,241,0,0,0,113,0,105,0,81,0,76,0,30,0,69,0,68,0,184,0,146,0,87,0,151,0,0,0,46,0,146,0,233,0,146,0,66,0,161,0,203,0,115,0,229,0,119,0,226,0,213,0,158,0,0,0,200,0,13,0,35,0,180,0,133,0,24,0,167,0,0,0,22,0,0,0,71,0,0,0,245,0,237,0,250,0,0,0,135,0,36,0,0,0,0,0,137,0,187,0,203,0,216,0,242,0,0,0,233,0,47,0,67,0,89,0,43,0,0,0,84,0,189,0,0,0,0,0,0,0,0,0,88,0,175,0,11,0,27,0,253,0,0,0,74,0,0,0,252,0,58,0,43,0,145,0,66,0,175,0,219,0,0,0,167,0,178,0,20,0,248,0,152,0,0,0,105,0,0,0,233,0,0,0,142,0,87,0,252,0,0,0,67,0,171,0,0,0,27,0,153,0,0,0,0,0,77,0,157,0,0,0,29,0,75,0,185,0,218,0,91,0,47,0,192,0,133,0,102,0,197,0,7,0,0,0,155,0,180,0,52,0,189,0,55,0,107,0,0,0,95,0,0,0,12,0,109,0,228,0,248,0,5,0,3,0,244,0,125,0,218,0,0,0,93,0,183,0,226,0,254,0,184,0,208,0,138,0,79,0,45,0,179,0,52,0,0,0,38,0,0,0,185,0,64,0,141,0,0,0,42,0,60,0,152,0,55,0,202,0,5,0,0,0,6,0,0,0,222,0,184,0,0,0,194,0,229,0,133,0,198,0,237,0,32,0,0,0,0,0,15,0,223,0,0,0,218,0,0,0,97,0,208,0,45,0,206,0,73,0,237,0,0,0,143,0,160,0,188,0,160,0,0,0,9,0,56,0,189,0,163,0,108,0,44,0,142,0,93,0,119,0,98,0,149,0,232,0,217,0,0,0,242,0,214,0,41,0,186,0,42,0,143,0,45,0,176,0,222,0,124,0,125,0,242,0,30,0,138,0,0,0,22,0,115,0,117,0,0,0,240,0,67,0,225,0,99,0,216,0,0,0,54,0,180,0,0,0,178,0,179,0,7,0,190,0,174,0,233,0,45,0,35,0,204,0,198,0,166,0,74,0,0,0,12,0,221,0,0,0,199,0);
signal scenario_full  : scenario_type := (0,0,202,31,241,31,77,31,48,31,15,31,169,31,169,30,96,31,202,31,245,31,61,31,63,31,203,31,203,30,151,31,72,31,52,31,52,30,197,31,28,31,219,31,99,31,99,30,98,31,71,31,71,30,192,31,160,31,240,31,96,31,96,30,96,29,96,28,225,31,225,30,159,31,94,31,236,31,43,31,164,31,164,30,164,29,244,31,238,31,62,31,103,31,82,31,120,31,92,31,252,31,199,31,59,31,9,31,208,31,210,31,38,31,15,31,218,31,44,31,44,30,98,31,108,31,114,31,87,31,216,31,152,31,220,31,207,31,207,30,18,31,83,31,111,31,7,31,64,31,144,31,3,31,3,30,162,31,154,31,239,31,197,31,225,31,222,31,241,31,241,30,113,31,105,31,81,31,76,31,30,31,69,31,68,31,184,31,146,31,87,31,151,31,151,30,46,31,146,31,233,31,146,31,66,31,161,31,203,31,115,31,229,31,119,31,226,31,213,31,158,31,158,30,200,31,13,31,35,31,180,31,133,31,24,31,167,31,167,30,22,31,22,30,71,31,71,30,245,31,237,31,250,31,250,30,135,31,36,31,36,30,36,29,137,31,187,31,203,31,216,31,242,31,242,30,233,31,47,31,67,31,89,31,43,31,43,30,84,31,189,31,189,30,189,29,189,28,189,27,88,31,175,31,11,31,27,31,253,31,253,30,74,31,74,30,252,31,58,31,43,31,145,31,66,31,175,31,219,31,219,30,167,31,178,31,20,31,248,31,152,31,152,30,105,31,105,30,233,31,233,30,142,31,87,31,252,31,252,30,67,31,171,31,171,30,27,31,153,31,153,30,153,29,77,31,157,31,157,30,29,31,75,31,185,31,218,31,91,31,47,31,192,31,133,31,102,31,197,31,7,31,7,30,155,31,180,31,52,31,189,31,55,31,107,31,107,30,95,31,95,30,12,31,109,31,228,31,248,31,5,31,3,31,244,31,125,31,218,31,218,30,93,31,183,31,226,31,254,31,184,31,208,31,138,31,79,31,45,31,179,31,52,31,52,30,38,31,38,30,185,31,64,31,141,31,141,30,42,31,60,31,152,31,55,31,202,31,5,31,5,30,6,31,6,30,222,31,184,31,184,30,194,31,229,31,133,31,198,31,237,31,32,31,32,30,32,29,15,31,223,31,223,30,218,31,218,30,97,31,208,31,45,31,206,31,73,31,237,31,237,30,143,31,160,31,188,31,160,31,160,30,9,31,56,31,189,31,163,31,108,31,44,31,142,31,93,31,119,31,98,31,149,31,232,31,217,31,217,30,242,31,214,31,41,31,186,31,42,31,143,31,45,31,176,31,222,31,124,31,125,31,242,31,30,31,138,31,138,30,22,31,115,31,117,31,117,30,240,31,67,31,225,31,99,31,216,31,216,30,54,31,180,31,180,30,178,31,179,31,7,31,190,31,174,31,233,31,45,31,35,31,204,31,198,31,166,31,74,31,74,30,12,31,221,31,221,30,199,31);

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
