-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_225 is
end project_tb_225;

architecture project_tb_arch_225 of project_tb_225 is
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

constant SCENARIO_LENGTH : integer := 599;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,84,0,0,0,242,0,246,0,171,0,112,0,225,0,60,0,0,0,245,0,127,0,108,0,104,0,0,0,234,0,41,0,0,0,239,0,0,0,115,0,70,0,102,0,141,0,69,0,15,0,22,0,191,0,0,0,0,0,0,0,133,0,172,0,87,0,121,0,114,0,1,0,106,0,157,0,0,0,134,0,16,0,48,0,0,0,221,0,34,0,145,0,0,0,69,0,16,0,0,0,82,0,166,0,185,0,90,0,71,0,0,0,26,0,221,0,226,0,123,0,191,0,8,0,162,0,0,0,157,0,0,0,125,0,0,0,154,0,0,0,234,0,192,0,212,0,164,0,185,0,114,0,43,0,222,0,19,0,188,0,203,0,152,0,99,0,76,0,2,0,139,0,242,0,84,0,199,0,132,0,244,0,74,0,0,0,0,0,230,0,107,0,10,0,222,0,182,0,0,0,140,0,0,0,86,0,63,0,21,0,167,0,212,0,133,0,81,0,0,0,59,0,107,0,214,0,190,0,114,0,145,0,5,0,246,0,225,0,253,0,16,0,154,0,62,0,77,0,116,0,0,0,26,0,161,0,0,0,88,0,0,0,43,0,0,0,92,0,0,0,220,0,120,0,0,0,114,0,65,0,122,0,209,0,59,0,12,0,57,0,65,0,3,0,177,0,242,0,60,0,0,0,39,0,0,0,0,0,0,0,67,0,156,0,85,0,141,0,120,0,61,0,195,0,171,0,0,0,212,0,0,0,84,0,158,0,142,0,145,0,1,0,144,0,247,0,198,0,0,0,0,0,0,0,0,0,235,0,208,0,200,0,170,0,132,0,202,0,3,0,76,0,133,0,0,0,0,0,226,0,0,0,165,0,0,0,0,0,230,0,145,0,185,0,26,0,0,0,35,0,38,0,219,0,106,0,173,0,248,0,122,0,58,0,226,0,227,0,72,0,33,0,0,0,42,0,22,0,117,0,217,0,0,0,100,0,135,0,104,0,142,0,146,0,0,0,9,0,86,0,113,0,156,0,235,0,0,0,251,0,94,0,240,0,219,0,0,0,0,0,97,0,145,0,220,0,167,0,137,0,176,0,17,0,43,0,0,0,0,0,0,0,72,0,102,0,0,0,0,0,40,0,26,0,170,0,171,0,6,0,0,0,175,0,0,0,200,0,6,0,141,0,162,0,0,0,26,0,46,0,88,0,224,0,147,0,33,0,133,0,206,0,204,0,83,0,0,0,213,0,0,0,216,0,31,0,163,0,247,0,222,0,2,0,0,0,0,0,0,0,74,0,94,0,88,0,2,0,34,0,127,0,0,0,207,0,245,0,100,0,101,0,9,0,249,0,17,0,110,0,0,0,32,0,79,0,74,0,63,0,202,0,194,0,139,0,89,0,125,0,0,0,170,0,15,0,0,0,192,0,0,0,100,0,150,0,193,0,168,0,46,0,255,0,48,0,18,0,140,0,44,0,5,0,98,0,0,0,0,0,227,0,32,0,215,0,44,0,115,0,105,0,225,0,253,0,238,0,126,0,203,0,147,0,89,0,0,0,0,0,162,0,87,0,241,0,190,0,0,0,138,0,181,0,0,0,66,0,129,0,105,0,0,0,238,0,2,0,108,0,0,0,0,0,30,0,18,0,90,0,38,0,0,0,109,0,134,0,206,0,0,0,0,0,172,0,178,0,0,0,126,0,42,0,236,0,197,0,0,0,92,0,128,0,59,0,133,0,250,0,85,0,131,0,183,0,252,0,206,0,204,0,238,0,24,0,32,0,130,0,80,0,29,0,104,0,115,0,143,0,4,0,236,0,198,0,0,0,166,0,206,0,155,0,181,0,132,0,191,0,151,0,108,0,185,0,238,0,103,0,101,0,85,0,108,0,179,0,0,0,68,0,217,0,49,0,19,0,49,0,11,0,44,0,184,0,31,0,25,0,114,0,140,0,0,0,0,0,123,0,232,0,4,0,158,0,48,0,164,0,140,0,82,0,90,0,114,0,35,0,146,0,97,0,171,0,158,0,0,0,209,0,0,0,132,0,0,0,133,0,116,0,0,0,0,0,106,0,0,0,63,0,243,0,65,0,0,0,0,0,180,0,0,0,29,0,239,0,121,0,0,0,154,0,121,0,0,0,206,0,12,0,174,0,66,0,14,0,155,0,197,0,172,0,175,0,0,0,176,0,236,0,29,0,141,0,231,0,0,0,65,0,77,0,0,0,139,0,228,0,55,0,31,0,213,0,0,0,0,0,95,0,27,0,50,0,207,0,0,0,79,0,170,0,170,0,25,0,189,0,0,0,13,0,252,0,229,0,55,0,120,0,61,0,237,0,52,0,240,0,0,0,67,0,0,0,0,0,138,0,219,0,97,0,30,0,0,0,172,0,214,0,86,0,77,0,0,0,143,0,157,0,132,0,162,0,0,0,0,0,37,0,170,0,53,0,84,0,207,0,0,0,164,0,0,0,0,0,13,0,188,0,0,0,127,0,223,0,90,0,160,0,98,0,1,0,2,0,0,0,192,0,192,0,90,0,187,0,242,0,0,0,111,0,0,0,221,0,143,0,109,0,0,0,110,0,23,0,164,0,0,0,248,0,215,0,237,0,24,0,126,0,32,0,236,0,0,0,135,0,179,0,0,0,142,0,0,0,251,0,156,0,103,0,43,0,43,0,68,0,202,0,132,0,92,0);
signal scenario_full  : scenario_type := (0,0,84,31,84,30,242,31,246,31,171,31,112,31,225,31,60,31,60,30,245,31,127,31,108,31,104,31,104,30,234,31,41,31,41,30,239,31,239,30,115,31,70,31,102,31,141,31,69,31,15,31,22,31,191,31,191,30,191,29,191,28,133,31,172,31,87,31,121,31,114,31,1,31,106,31,157,31,157,30,134,31,16,31,48,31,48,30,221,31,34,31,145,31,145,30,69,31,16,31,16,30,82,31,166,31,185,31,90,31,71,31,71,30,26,31,221,31,226,31,123,31,191,31,8,31,162,31,162,30,157,31,157,30,125,31,125,30,154,31,154,30,234,31,192,31,212,31,164,31,185,31,114,31,43,31,222,31,19,31,188,31,203,31,152,31,99,31,76,31,2,31,139,31,242,31,84,31,199,31,132,31,244,31,74,31,74,30,74,29,230,31,107,31,10,31,222,31,182,31,182,30,140,31,140,30,86,31,63,31,21,31,167,31,212,31,133,31,81,31,81,30,59,31,107,31,214,31,190,31,114,31,145,31,5,31,246,31,225,31,253,31,16,31,154,31,62,31,77,31,116,31,116,30,26,31,161,31,161,30,88,31,88,30,43,31,43,30,92,31,92,30,220,31,120,31,120,30,114,31,65,31,122,31,209,31,59,31,12,31,57,31,65,31,3,31,177,31,242,31,60,31,60,30,39,31,39,30,39,29,39,28,67,31,156,31,85,31,141,31,120,31,61,31,195,31,171,31,171,30,212,31,212,30,84,31,158,31,142,31,145,31,1,31,144,31,247,31,198,31,198,30,198,29,198,28,198,27,235,31,208,31,200,31,170,31,132,31,202,31,3,31,76,31,133,31,133,30,133,29,226,31,226,30,165,31,165,30,165,29,230,31,145,31,185,31,26,31,26,30,35,31,38,31,219,31,106,31,173,31,248,31,122,31,58,31,226,31,227,31,72,31,33,31,33,30,42,31,22,31,117,31,217,31,217,30,100,31,135,31,104,31,142,31,146,31,146,30,9,31,86,31,113,31,156,31,235,31,235,30,251,31,94,31,240,31,219,31,219,30,219,29,97,31,145,31,220,31,167,31,137,31,176,31,17,31,43,31,43,30,43,29,43,28,72,31,102,31,102,30,102,29,40,31,26,31,170,31,171,31,6,31,6,30,175,31,175,30,200,31,6,31,141,31,162,31,162,30,26,31,46,31,88,31,224,31,147,31,33,31,133,31,206,31,204,31,83,31,83,30,213,31,213,30,216,31,31,31,163,31,247,31,222,31,2,31,2,30,2,29,2,28,74,31,94,31,88,31,2,31,34,31,127,31,127,30,207,31,245,31,100,31,101,31,9,31,249,31,17,31,110,31,110,30,32,31,79,31,74,31,63,31,202,31,194,31,139,31,89,31,125,31,125,30,170,31,15,31,15,30,192,31,192,30,100,31,150,31,193,31,168,31,46,31,255,31,48,31,18,31,140,31,44,31,5,31,98,31,98,30,98,29,227,31,32,31,215,31,44,31,115,31,105,31,225,31,253,31,238,31,126,31,203,31,147,31,89,31,89,30,89,29,162,31,87,31,241,31,190,31,190,30,138,31,181,31,181,30,66,31,129,31,105,31,105,30,238,31,2,31,108,31,108,30,108,29,30,31,18,31,90,31,38,31,38,30,109,31,134,31,206,31,206,30,206,29,172,31,178,31,178,30,126,31,42,31,236,31,197,31,197,30,92,31,128,31,59,31,133,31,250,31,85,31,131,31,183,31,252,31,206,31,204,31,238,31,24,31,32,31,130,31,80,31,29,31,104,31,115,31,143,31,4,31,236,31,198,31,198,30,166,31,206,31,155,31,181,31,132,31,191,31,151,31,108,31,185,31,238,31,103,31,101,31,85,31,108,31,179,31,179,30,68,31,217,31,49,31,19,31,49,31,11,31,44,31,184,31,31,31,25,31,114,31,140,31,140,30,140,29,123,31,232,31,4,31,158,31,48,31,164,31,140,31,82,31,90,31,114,31,35,31,146,31,97,31,171,31,158,31,158,30,209,31,209,30,132,31,132,30,133,31,116,31,116,30,116,29,106,31,106,30,63,31,243,31,65,31,65,30,65,29,180,31,180,30,29,31,239,31,121,31,121,30,154,31,121,31,121,30,206,31,12,31,174,31,66,31,14,31,155,31,197,31,172,31,175,31,175,30,176,31,236,31,29,31,141,31,231,31,231,30,65,31,77,31,77,30,139,31,228,31,55,31,31,31,213,31,213,30,213,29,95,31,27,31,50,31,207,31,207,30,79,31,170,31,170,31,25,31,189,31,189,30,13,31,252,31,229,31,55,31,120,31,61,31,237,31,52,31,240,31,240,30,67,31,67,30,67,29,138,31,219,31,97,31,30,31,30,30,172,31,214,31,86,31,77,31,77,30,143,31,157,31,132,31,162,31,162,30,162,29,37,31,170,31,53,31,84,31,207,31,207,30,164,31,164,30,164,29,13,31,188,31,188,30,127,31,223,31,90,31,160,31,98,31,1,31,2,31,2,30,192,31,192,31,90,31,187,31,242,31,242,30,111,31,111,30,221,31,143,31,109,31,109,30,110,31,23,31,164,31,164,30,248,31,215,31,237,31,24,31,126,31,32,31,236,31,236,30,135,31,179,31,179,30,142,31,142,30,251,31,156,31,103,31,43,31,43,31,68,31,202,31,132,31,92,31);

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
