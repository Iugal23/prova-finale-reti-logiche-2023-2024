-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_501 is
end project_tb_501;

architecture project_tb_arch_501 of project_tb_501 is
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

constant SCENARIO_LENGTH : integer := 547;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (138,0,103,0,168,0,145,0,180,0,253,0,76,0,175,0,210,0,1,0,0,0,92,0,132,0,0,0,217,0,38,0,157,0,246,0,0,0,240,0,100,0,0,0,0,0,0,0,171,0,144,0,166,0,228,0,151,0,14,0,196,0,45,0,234,0,110,0,233,0,82,0,62,0,90,0,0,0,77,0,66,0,0,0,35,0,13,0,0,0,0,0,178,0,154,0,154,0,78,0,201,0,7,0,181,0,23,0,150,0,226,0,90,0,120,0,0,0,119,0,243,0,199,0,108,0,160,0,237,0,114,0,205,0,252,0,166,0,213,0,120,0,12,0,209,0,0,0,108,0,13,0,47,0,130,0,57,0,172,0,144,0,0,0,0,0,32,0,109,0,148,0,209,0,48,0,49,0,0,0,78,0,149,0,153,0,32,0,235,0,176,0,202,0,86,0,214,0,255,0,59,0,54,0,127,0,219,0,244,0,221,0,210,0,41,0,116,0,0,0,254,0,10,0,0,0,78,0,18,0,0,0,62,0,0,0,18,0,239,0,185,0,197,0,80,0,196,0,0,0,134,0,0,0,214,0,114,0,66,0,57,0,86,0,0,0,144,0,0,0,141,0,0,0,205,0,0,0,54,0,220,0,80,0,3,0,0,0,233,0,0,0,146,0,91,0,115,0,59,0,177,0,75,0,42,0,72,0,38,0,41,0,214,0,249,0,141,0,242,0,0,0,113,0,34,0,5,0,0,0,148,0,162,0,58,0,27,0,246,0,81,0,174,0,246,0,136,0,229,0,0,0,74,0,200,0,156,0,32,0,253,0,83,0,0,0,0,0,248,0,148,0,187,0,113,0,138,0,128,0,58,0,105,0,7,0,167,0,74,0,0,0,142,0,167,0,25,0,189,0,126,0,100,0,0,0,189,0,151,0,40,0,123,0,163,0,0,0,30,0,133,0,228,0,159,0,138,0,30,0,208,0,0,0,180,0,133,0,0,0,104,0,167,0,83,0,0,0,88,0,38,0,164,0,231,0,223,0,34,0,1,0,143,0,0,0,50,0,221,0,0,0,160,0,49,0,115,0,93,0,0,0,201,0,156,0,244,0,232,0,192,0,144,0,170,0,147,0,127,0,127,0,205,0,27,0,24,0,166,0,57,0,109,0,0,0,0,0,41,0,104,0,0,0,106,0,0,0,135,0,139,0,245,0,85,0,253,0,209,0,21,0,0,0,175,0,120,0,185,0,108,0,63,0,111,0,0,0,0,0,90,0,95,0,0,0,0,0,121,0,16,0,233,0,3,0,0,0,0,0,0,0,74,0,169,0,212,0,195,0,133,0,147,0,221,0,26,0,86,0,158,0,50,0,231,0,162,0,188,0,0,0,139,0,0,0,64,0,48,0,252,0,0,0,212,0,0,0,0,0,181,0,246,0,59,0,157,0,0,0,60,0,79,0,26,0,218,0,128,0,95,0,179,0,21,0,0,0,72,0,213,0,208,0,215,0,141,0,183,0,142,0,0,0,124,0,232,0,129,0,93,0,57,0,74,0,206,0,230,0,132,0,187,0,92,0,106,0,25,0,195,0,198,0,196,0,60,0,69,0,247,0,43,0,109,0,0,0,0,0,0,0,164,0,22,0,193,0,71,0,54,0,0,0,143,0,239,0,241,0,151,0,0,0,0,0,1,0,65,0,60,0,119,0,250,0,25,0,0,0,177,0,8,0,71,0,64,0,37,0,228,0,0,0,0,0,34,0,34,0,229,0,82,0,103,0,0,0,0,0,17,0,200,0,167,0,0,0,153,0,54,0,8,0,168,0,54,0,250,0,181,0,186,0,159,0,140,0,0,0,32,0,80,0,184,0,25,0,0,0,85,0,126,0,27,0,242,0,82,0,149,0,252,0,206,0,15,0,93,0,84,0,177,0,160,0,115,0,80,0,50,0,248,0,19,0,0,0,126,0,29,0,151,0,63,0,6,0,149,0,232,0,197,0,135,0,201,0,134,0,179,0,169,0,3,0,199,0,72,0,195,0,0,0,0,0,0,0,247,0,187,0,67,0,65,0,0,0,42,0,143,0,0,0,0,0,0,0,0,0,41,0,182,0,190,0,0,0,0,0,113,0,78,0,0,0,0,0,241,0,16,0,134,0,221,0,111,0,222,0,89,0,42,0,216,0,0,0,0,0,234,0,211,0,97,0,76,0,73,0,244,0,68,0,45,0,79,0,0,0,206,0,206,0,62,0,234,0,85,0,235,0,190,0,0,0,111,0,0,0,0,0,240,0,197,0,5,0,1,0,112,0,173,0,215,0,0,0,230,0,64,0,0,0,57,0,42,0,68,0,103,0,21,0,8,0,207,0,0,0,169,0,0,0,5,0,0,0,0,0,73,0,181,0,12,0,197,0,144,0,93,0,182,0,98,0,66,0,128,0,0,0,50,0,10,0,26,0,127,0,4,0,160,0);
signal scenario_full  : scenario_type := (138,31,103,31,168,31,145,31,180,31,253,31,76,31,175,31,210,31,1,31,1,30,92,31,132,31,132,30,217,31,38,31,157,31,246,31,246,30,240,31,100,31,100,30,100,29,100,28,171,31,144,31,166,31,228,31,151,31,14,31,196,31,45,31,234,31,110,31,233,31,82,31,62,31,90,31,90,30,77,31,66,31,66,30,35,31,13,31,13,30,13,29,178,31,154,31,154,31,78,31,201,31,7,31,181,31,23,31,150,31,226,31,90,31,120,31,120,30,119,31,243,31,199,31,108,31,160,31,237,31,114,31,205,31,252,31,166,31,213,31,120,31,12,31,209,31,209,30,108,31,13,31,47,31,130,31,57,31,172,31,144,31,144,30,144,29,32,31,109,31,148,31,209,31,48,31,49,31,49,30,78,31,149,31,153,31,32,31,235,31,176,31,202,31,86,31,214,31,255,31,59,31,54,31,127,31,219,31,244,31,221,31,210,31,41,31,116,31,116,30,254,31,10,31,10,30,78,31,18,31,18,30,62,31,62,30,18,31,239,31,185,31,197,31,80,31,196,31,196,30,134,31,134,30,214,31,114,31,66,31,57,31,86,31,86,30,144,31,144,30,141,31,141,30,205,31,205,30,54,31,220,31,80,31,3,31,3,30,233,31,233,30,146,31,91,31,115,31,59,31,177,31,75,31,42,31,72,31,38,31,41,31,214,31,249,31,141,31,242,31,242,30,113,31,34,31,5,31,5,30,148,31,162,31,58,31,27,31,246,31,81,31,174,31,246,31,136,31,229,31,229,30,74,31,200,31,156,31,32,31,253,31,83,31,83,30,83,29,248,31,148,31,187,31,113,31,138,31,128,31,58,31,105,31,7,31,167,31,74,31,74,30,142,31,167,31,25,31,189,31,126,31,100,31,100,30,189,31,151,31,40,31,123,31,163,31,163,30,30,31,133,31,228,31,159,31,138,31,30,31,208,31,208,30,180,31,133,31,133,30,104,31,167,31,83,31,83,30,88,31,38,31,164,31,231,31,223,31,34,31,1,31,143,31,143,30,50,31,221,31,221,30,160,31,49,31,115,31,93,31,93,30,201,31,156,31,244,31,232,31,192,31,144,31,170,31,147,31,127,31,127,31,205,31,27,31,24,31,166,31,57,31,109,31,109,30,109,29,41,31,104,31,104,30,106,31,106,30,135,31,139,31,245,31,85,31,253,31,209,31,21,31,21,30,175,31,120,31,185,31,108,31,63,31,111,31,111,30,111,29,90,31,95,31,95,30,95,29,121,31,16,31,233,31,3,31,3,30,3,29,3,28,74,31,169,31,212,31,195,31,133,31,147,31,221,31,26,31,86,31,158,31,50,31,231,31,162,31,188,31,188,30,139,31,139,30,64,31,48,31,252,31,252,30,212,31,212,30,212,29,181,31,246,31,59,31,157,31,157,30,60,31,79,31,26,31,218,31,128,31,95,31,179,31,21,31,21,30,72,31,213,31,208,31,215,31,141,31,183,31,142,31,142,30,124,31,232,31,129,31,93,31,57,31,74,31,206,31,230,31,132,31,187,31,92,31,106,31,25,31,195,31,198,31,196,31,60,31,69,31,247,31,43,31,109,31,109,30,109,29,109,28,164,31,22,31,193,31,71,31,54,31,54,30,143,31,239,31,241,31,151,31,151,30,151,29,1,31,65,31,60,31,119,31,250,31,25,31,25,30,177,31,8,31,71,31,64,31,37,31,228,31,228,30,228,29,34,31,34,31,229,31,82,31,103,31,103,30,103,29,17,31,200,31,167,31,167,30,153,31,54,31,8,31,168,31,54,31,250,31,181,31,186,31,159,31,140,31,140,30,32,31,80,31,184,31,25,31,25,30,85,31,126,31,27,31,242,31,82,31,149,31,252,31,206,31,15,31,93,31,84,31,177,31,160,31,115,31,80,31,50,31,248,31,19,31,19,30,126,31,29,31,151,31,63,31,6,31,149,31,232,31,197,31,135,31,201,31,134,31,179,31,169,31,3,31,199,31,72,31,195,31,195,30,195,29,195,28,247,31,187,31,67,31,65,31,65,30,42,31,143,31,143,30,143,29,143,28,143,27,41,31,182,31,190,31,190,30,190,29,113,31,78,31,78,30,78,29,241,31,16,31,134,31,221,31,111,31,222,31,89,31,42,31,216,31,216,30,216,29,234,31,211,31,97,31,76,31,73,31,244,31,68,31,45,31,79,31,79,30,206,31,206,31,62,31,234,31,85,31,235,31,190,31,190,30,111,31,111,30,111,29,240,31,197,31,5,31,1,31,112,31,173,31,215,31,215,30,230,31,64,31,64,30,57,31,42,31,68,31,103,31,21,31,8,31,207,31,207,30,169,31,169,30,5,31,5,30,5,29,73,31,181,31,12,31,197,31,144,31,93,31,182,31,98,31,66,31,128,31,128,30,50,31,10,31,26,31,127,31,4,31,160,31);

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
