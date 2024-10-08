-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_365 is
end project_tb_365;

architecture project_tb_arch_365 of project_tb_365 is
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

constant SCENARIO_LENGTH : integer := 407;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,80,0,0,0,59,0,29,0,0,0,135,0,23,0,0,0,251,0,0,0,168,0,129,0,0,0,239,0,244,0,182,0,155,0,0,0,110,0,0,0,204,0,112,0,0,0,0,0,97,0,207,0,184,0,244,0,10,0,148,0,4,0,107,0,231,0,29,0,0,0,161,0,123,0,141,0,0,0,0,0,197,0,122,0,214,0,210,0,0,0,155,0,0,0,5,0,0,0,233,0,142,0,115,0,194,0,0,0,175,0,0,0,176,0,24,0,231,0,83,0,218,0,239,0,234,0,223,0,0,0,85,0,37,0,70,0,139,0,0,0,117,0,161,0,0,0,243,0,0,0,195,0,135,0,0,0,32,0,176,0,136,0,255,0,27,0,145,0,116,0,116,0,251,0,16,0,0,0,181,0,165,0,0,0,0,0,108,0,100,0,167,0,127,0,219,0,48,0,0,0,37,0,109,0,0,0,230,0,0,0,117,0,207,0,0,0,204,0,160,0,168,0,0,0,32,0,91,0,27,0,0,0,0,0,50,0,0,0,52,0,131,0,152,0,199,0,93,0,169,0,121,0,131,0,153,0,229,0,42,0,140,0,159,0,158,0,191,0,0,0,108,0,214,0,0,0,0,0,116,0,15,0,174,0,0,0,191,0,124,0,81,0,240,0,167,0,220,0,234,0,58,0,152,0,48,0,0,0,131,0,144,0,49,0,191,0,131,0,119,0,82,0,161,0,206,0,0,0,33,0,223,0,0,0,132,0,2,0,250,0,130,0,18,0,70,0,0,0,35,0,167,0,187,0,253,0,0,0,185,0,184,0,239,0,133,0,0,0,0,0,112,0,107,0,33,0,227,0,31,0,224,0,139,0,244,0,221,0,87,0,0,0,0,0,235,0,77,0,167,0,224,0,0,0,0,0,0,0,31,0,0,0,15,0,0,0,247,0,215,0,0,0,0,0,0,0,155,0,107,0,157,0,91,0,224,0,62,0,246,0,250,0,136,0,61,0,169,0,222,0,35,0,219,0,0,0,196,0,187,0,28,0,122,0,49,0,162,0,190,0,0,0,0,0,161,0,232,0,168,0,88,0,97,0,103,0,172,0,158,0,197,0,176,0,80,0,206,0,206,0,241,0,0,0,240,0,1,0,7,0,189,0,168,0,0,0,108,0,26,0,0,0,231,0,133,0,54,0,27,0,144,0,218,0,42,0,78,0,0,0,230,0,218,0,0,0,249,0,42,0,155,0,176,0,16,0,78,0,188,0,100,0,247,0,81,0,204,0,0,0,0,0,94,0,183,0,43,0,85,0,186,0,103,0,75,0,0,0,32,0,0,0,181,0,191,0,169,0,32,0,0,0,0,0,34,0,0,0,164,0,69,0,223,0,21,0,133,0,161,0,0,0,138,0,77,0,18,0,131,0,169,0,73,0,103,0,249,0,212,0,186,0,253,0,165,0,176,0,0,0,22,0,108,0,245,0,83,0,146,0,70,0,73,0,190,0,63,0,217,0,12,0,214,0,242,0,119,0,106,0,35,0,190,0,213,0,10,0,0,0,246,0,217,0,129,0,141,0,99,0,43,0,116,0,91,0,15,0,230,0,153,0,37,0,182,0,7,0,209,0,190,0,0,0,0,0,183,0,28,0,215,0,164,0,0,0,53,0,142,0,129,0,0,0,64,0,129,0,237,0,12,0,83,0,26,0,97,0,161,0,120,0,64,0,0,0,100,0,226,0,238,0,1,0,0,0,0,0,0,0,91,0,217,0,233,0,222,0,136,0,215,0,114,0,0,0,234,0,207,0,214,0,33,0,252,0,81,0,48,0);
signal scenario_full  : scenario_type := (0,0,0,0,80,31,80,30,59,31,29,31,29,30,135,31,23,31,23,30,251,31,251,30,168,31,129,31,129,30,239,31,244,31,182,31,155,31,155,30,110,31,110,30,204,31,112,31,112,30,112,29,97,31,207,31,184,31,244,31,10,31,148,31,4,31,107,31,231,31,29,31,29,30,161,31,123,31,141,31,141,30,141,29,197,31,122,31,214,31,210,31,210,30,155,31,155,30,5,31,5,30,233,31,142,31,115,31,194,31,194,30,175,31,175,30,176,31,24,31,231,31,83,31,218,31,239,31,234,31,223,31,223,30,85,31,37,31,70,31,139,31,139,30,117,31,161,31,161,30,243,31,243,30,195,31,135,31,135,30,32,31,176,31,136,31,255,31,27,31,145,31,116,31,116,31,251,31,16,31,16,30,181,31,165,31,165,30,165,29,108,31,100,31,167,31,127,31,219,31,48,31,48,30,37,31,109,31,109,30,230,31,230,30,117,31,207,31,207,30,204,31,160,31,168,31,168,30,32,31,91,31,27,31,27,30,27,29,50,31,50,30,52,31,131,31,152,31,199,31,93,31,169,31,121,31,131,31,153,31,229,31,42,31,140,31,159,31,158,31,191,31,191,30,108,31,214,31,214,30,214,29,116,31,15,31,174,31,174,30,191,31,124,31,81,31,240,31,167,31,220,31,234,31,58,31,152,31,48,31,48,30,131,31,144,31,49,31,191,31,131,31,119,31,82,31,161,31,206,31,206,30,33,31,223,31,223,30,132,31,2,31,250,31,130,31,18,31,70,31,70,30,35,31,167,31,187,31,253,31,253,30,185,31,184,31,239,31,133,31,133,30,133,29,112,31,107,31,33,31,227,31,31,31,224,31,139,31,244,31,221,31,87,31,87,30,87,29,235,31,77,31,167,31,224,31,224,30,224,29,224,28,31,31,31,30,15,31,15,30,247,31,215,31,215,30,215,29,215,28,155,31,107,31,157,31,91,31,224,31,62,31,246,31,250,31,136,31,61,31,169,31,222,31,35,31,219,31,219,30,196,31,187,31,28,31,122,31,49,31,162,31,190,31,190,30,190,29,161,31,232,31,168,31,88,31,97,31,103,31,172,31,158,31,197,31,176,31,80,31,206,31,206,31,241,31,241,30,240,31,1,31,7,31,189,31,168,31,168,30,108,31,26,31,26,30,231,31,133,31,54,31,27,31,144,31,218,31,42,31,78,31,78,30,230,31,218,31,218,30,249,31,42,31,155,31,176,31,16,31,78,31,188,31,100,31,247,31,81,31,204,31,204,30,204,29,94,31,183,31,43,31,85,31,186,31,103,31,75,31,75,30,32,31,32,30,181,31,191,31,169,31,32,31,32,30,32,29,34,31,34,30,164,31,69,31,223,31,21,31,133,31,161,31,161,30,138,31,77,31,18,31,131,31,169,31,73,31,103,31,249,31,212,31,186,31,253,31,165,31,176,31,176,30,22,31,108,31,245,31,83,31,146,31,70,31,73,31,190,31,63,31,217,31,12,31,214,31,242,31,119,31,106,31,35,31,190,31,213,31,10,31,10,30,246,31,217,31,129,31,141,31,99,31,43,31,116,31,91,31,15,31,230,31,153,31,37,31,182,31,7,31,209,31,190,31,190,30,190,29,183,31,28,31,215,31,164,31,164,30,53,31,142,31,129,31,129,30,64,31,129,31,237,31,12,31,83,31,26,31,97,31,161,31,120,31,64,31,64,30,100,31,226,31,238,31,1,31,1,30,1,29,1,28,91,31,217,31,233,31,222,31,136,31,215,31,114,31,114,30,234,31,207,31,214,31,33,31,252,31,81,31,48,31);

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
