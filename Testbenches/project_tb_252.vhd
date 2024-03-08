-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_252 is
end project_tb_252;

architecture project_tb_arch_252 of project_tb_252 is
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

constant SCENARIO_LENGTH : integer := 678;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,96,0,0,0,0,0,21,0,178,0,222,0,57,0,210,0,175,0,171,0,108,0,158,0,113,0,181,0,103,0,152,0,13,0,7,0,148,0,79,0,195,0,150,0,0,0,131,0,173,0,143,0,199,0,216,0,199,0,103,0,156,0,0,0,98,0,0,0,0,0,123,0,75,0,211,0,222,0,26,0,237,0,17,0,58,0,81,0,170,0,44,0,231,0,0,0,131,0,0,0,0,0,163,0,235,0,15,0,148,0,29,0,71,0,0,0,29,0,212,0,0,0,252,0,5,0,146,0,92,0,0,0,141,0,47,0,0,0,0,0,112,0,208,0,95,0,85,0,198,0,80,0,236,0,236,0,0,0,175,0,81,0,23,0,185,0,159,0,62,0,0,0,85,0,145,0,207,0,0,0,115,0,42,0,29,0,15,0,127,0,19,0,82,0,229,0,0,0,255,0,51,0,46,0,0,0,105,0,211,0,84,0,150,0,196,0,220,0,56,0,0,0,210,0,181,0,235,0,53,0,87,0,3,0,3,0,219,0,192,0,40,0,5,0,0,0,0,0,104,0,240,0,29,0,161,0,134,0,203,0,246,0,242,0,0,0,101,0,55,0,253,0,0,0,131,0,121,0,33,0,0,0,0,0,146,0,0,0,94,0,80,0,0,0,226,0,41,0,27,0,0,0,28,0,202,0,197,0,238,0,241,0,240,0,103,0,216,0,149,0,51,0,127,0,204,0,85,0,0,0,108,0,177,0,217,0,163,0,212,0,0,0,245,0,1,0,0,0,108,0,168,0,46,0,0,0,185,0,175,0,232,0,117,0,0,0,204,0,41,0,2,0,152,0,0,0,173,0,128,0,129,0,0,0,160,0,176,0,238,0,0,0,132,0,203,0,97,0,0,0,224,0,181,0,50,0,111,0,6,0,255,0,11,0,116,0,0,0,219,0,136,0,237,0,0,0,191,0,212,0,194,0,121,0,127,0,153,0,81,0,0,0,0,0,95,0,174,0,208,0,30,0,43,0,13,0,73,0,40,0,168,0,108,0,0,0,241,0,100,0,88,0,23,0,0,0,8,0,231,0,42,0,193,0,180,0,9,0,212,0,0,0,175,0,117,0,116,0,48,0,49,0,200,0,210,0,0,0,251,0,228,0,21,0,253,0,152,0,132,0,152,0,108,0,104,0,60,0,75,0,159,0,96,0,213,0,74,0,6,0,153,0,143,0,244,0,57,0,245,0,15,0,184,0,68,0,0,0,63,0,184,0,40,0,0,0,253,0,179,0,51,0,27,0,249,0,0,0,6,0,223,0,79,0,141,0,186,0,199,0,122,0,134,0,87,0,195,0,150,0,26,0,203,0,251,0,159,0,210,0,196,0,47,0,33,0,112,0,23,0,113,0,200,0,227,0,0,0,50,0,220,0,48,0,41,0,86,0,153,0,64,0,0,0,162,0,73,0,0,0,189,0,23,0,30,0,114,0,0,0,67,0,74,0,0,0,182,0,147,0,0,0,69,0,0,0,0,0,0,0,0,0,177,0,156,0,0,0,85,0,132,0,14,0,193,0,214,0,244,0,65,0,251,0,0,0,69,0,132,0,145,0,0,0,23,0,7,0,0,0,225,0,132,0,0,0,85,0,43,0,8,0,230,0,199,0,142,0,47,0,24,0,187,0,0,0,0,0,0,0,89,0,19,0,202,0,0,0,121,0,0,0,165,0,39,0,0,0,53,0,224,0,0,0,176,0,0,0,207,0,89,0,0,0,162,0,53,0,253,0,120,0,254,0,0,0,17,0,173,0,7,0,33,0,85,0,66,0,116,0,17,0,230,0,231,0,226,0,185,0,232,0,172,0,225,0,206,0,114,0,0,0,31,0,13,0,199,0,146,0,156,0,52,0,144,0,91,0,67,0,243,0,165,0,0,0,165,0,171,0,213,0,0,0,179,0,197,0,44,0,154,0,0,0,252,0,183,0,0,0,199,0,21,0,36,0,0,0,247,0,123,0,15,0,125,0,9,0,43,0,136,0,124,0,3,0,24,0,78,0,197,0,229,0,0,0,100,0,223,0,79,0,93,0,166,0,29,0,82,0,98,0,0,0,0,0,245,0,7,0,207,0,0,0,49,0,207,0,140,0,0,0,89,0,208,0,62,0,37,0,216,0,0,0,0,0,92,0,240,0,181,0,0,0,208,0,50,0,3,0,0,0,0,0,129,0,0,0,253,0,181,0,199,0,16,0,146,0,34,0,100,0,210,0,102,0,74,0,187,0,114,0,16,0,46,0,5,0,54,0,0,0,0,0,152,0,25,0,82,0,142,0,31,0,108,0,0,0,0,0,0,0,101,0,177,0,40,0,15,0,223,0,202,0,64,0,201,0,253,0,213,0,0,0,179,0,0,0,236,0,0,0,69,0,0,0,241,0,0,0,0,0,51,0,0,0,104,0,0,0,45,0,238,0,0,0,0,0,198,0,0,0,230,0,164,0,118,0,0,0,0,0,93,0,66,0,16,0,196,0,83,0,0,0,0,0,122,0,185,0,0,0,138,0,41,0,0,0,149,0,150,0,75,0,212,0,92,0,221,0,0,0,132,0,10,0,185,0,1,0,73,0,168,0,110,0,8,0,41,0,190,0,246,0,0,0,150,0,231,0,61,0,0,0,240,0,60,0,212,0,156,0,93,0,0,0,0,0,0,0,75,0,215,0,232,0,70,0,181,0,248,0,234,0,195,0,0,0,0,0,15,0,119,0,8,0,54,0,206,0,65,0,83,0,211,0,91,0,0,0,67,0,123,0,70,0,0,0,90,0,0,0,247,0,0,0,84,0,0,0,133,0,176,0,82,0,210,0,229,0,186,0,17,0,17,0,65,0,160,0,0,0,0,0,237,0,3,0,0,0,82,0,210,0,165,0,0,0,163,0,0,0,0,0,4,0,233,0,62,0,189,0,124,0,0,0,0,0,29,0,0,0,117,0,0,0,0,0,109,0,0,0,159,0,72,0,0,0,196,0,226,0,56,0,151,0,132,0,104,0,81,0,109,0);
signal scenario_full  : scenario_type := (0,0,96,31,96,30,96,29,21,31,178,31,222,31,57,31,210,31,175,31,171,31,108,31,158,31,113,31,181,31,103,31,152,31,13,31,7,31,148,31,79,31,195,31,150,31,150,30,131,31,173,31,143,31,199,31,216,31,199,31,103,31,156,31,156,30,98,31,98,30,98,29,123,31,75,31,211,31,222,31,26,31,237,31,17,31,58,31,81,31,170,31,44,31,231,31,231,30,131,31,131,30,131,29,163,31,235,31,15,31,148,31,29,31,71,31,71,30,29,31,212,31,212,30,252,31,5,31,146,31,92,31,92,30,141,31,47,31,47,30,47,29,112,31,208,31,95,31,85,31,198,31,80,31,236,31,236,31,236,30,175,31,81,31,23,31,185,31,159,31,62,31,62,30,85,31,145,31,207,31,207,30,115,31,42,31,29,31,15,31,127,31,19,31,82,31,229,31,229,30,255,31,51,31,46,31,46,30,105,31,211,31,84,31,150,31,196,31,220,31,56,31,56,30,210,31,181,31,235,31,53,31,87,31,3,31,3,31,219,31,192,31,40,31,5,31,5,30,5,29,104,31,240,31,29,31,161,31,134,31,203,31,246,31,242,31,242,30,101,31,55,31,253,31,253,30,131,31,121,31,33,31,33,30,33,29,146,31,146,30,94,31,80,31,80,30,226,31,41,31,27,31,27,30,28,31,202,31,197,31,238,31,241,31,240,31,103,31,216,31,149,31,51,31,127,31,204,31,85,31,85,30,108,31,177,31,217,31,163,31,212,31,212,30,245,31,1,31,1,30,108,31,168,31,46,31,46,30,185,31,175,31,232,31,117,31,117,30,204,31,41,31,2,31,152,31,152,30,173,31,128,31,129,31,129,30,160,31,176,31,238,31,238,30,132,31,203,31,97,31,97,30,224,31,181,31,50,31,111,31,6,31,255,31,11,31,116,31,116,30,219,31,136,31,237,31,237,30,191,31,212,31,194,31,121,31,127,31,153,31,81,31,81,30,81,29,95,31,174,31,208,31,30,31,43,31,13,31,73,31,40,31,168,31,108,31,108,30,241,31,100,31,88,31,23,31,23,30,8,31,231,31,42,31,193,31,180,31,9,31,212,31,212,30,175,31,117,31,116,31,48,31,49,31,200,31,210,31,210,30,251,31,228,31,21,31,253,31,152,31,132,31,152,31,108,31,104,31,60,31,75,31,159,31,96,31,213,31,74,31,6,31,153,31,143,31,244,31,57,31,245,31,15,31,184,31,68,31,68,30,63,31,184,31,40,31,40,30,253,31,179,31,51,31,27,31,249,31,249,30,6,31,223,31,79,31,141,31,186,31,199,31,122,31,134,31,87,31,195,31,150,31,26,31,203,31,251,31,159,31,210,31,196,31,47,31,33,31,112,31,23,31,113,31,200,31,227,31,227,30,50,31,220,31,48,31,41,31,86,31,153,31,64,31,64,30,162,31,73,31,73,30,189,31,23,31,30,31,114,31,114,30,67,31,74,31,74,30,182,31,147,31,147,30,69,31,69,30,69,29,69,28,69,27,177,31,156,31,156,30,85,31,132,31,14,31,193,31,214,31,244,31,65,31,251,31,251,30,69,31,132,31,145,31,145,30,23,31,7,31,7,30,225,31,132,31,132,30,85,31,43,31,8,31,230,31,199,31,142,31,47,31,24,31,187,31,187,30,187,29,187,28,89,31,19,31,202,31,202,30,121,31,121,30,165,31,39,31,39,30,53,31,224,31,224,30,176,31,176,30,207,31,89,31,89,30,162,31,53,31,253,31,120,31,254,31,254,30,17,31,173,31,7,31,33,31,85,31,66,31,116,31,17,31,230,31,231,31,226,31,185,31,232,31,172,31,225,31,206,31,114,31,114,30,31,31,13,31,199,31,146,31,156,31,52,31,144,31,91,31,67,31,243,31,165,31,165,30,165,31,171,31,213,31,213,30,179,31,197,31,44,31,154,31,154,30,252,31,183,31,183,30,199,31,21,31,36,31,36,30,247,31,123,31,15,31,125,31,9,31,43,31,136,31,124,31,3,31,24,31,78,31,197,31,229,31,229,30,100,31,223,31,79,31,93,31,166,31,29,31,82,31,98,31,98,30,98,29,245,31,7,31,207,31,207,30,49,31,207,31,140,31,140,30,89,31,208,31,62,31,37,31,216,31,216,30,216,29,92,31,240,31,181,31,181,30,208,31,50,31,3,31,3,30,3,29,129,31,129,30,253,31,181,31,199,31,16,31,146,31,34,31,100,31,210,31,102,31,74,31,187,31,114,31,16,31,46,31,5,31,54,31,54,30,54,29,152,31,25,31,82,31,142,31,31,31,108,31,108,30,108,29,108,28,101,31,177,31,40,31,15,31,223,31,202,31,64,31,201,31,253,31,213,31,213,30,179,31,179,30,236,31,236,30,69,31,69,30,241,31,241,30,241,29,51,31,51,30,104,31,104,30,45,31,238,31,238,30,238,29,198,31,198,30,230,31,164,31,118,31,118,30,118,29,93,31,66,31,16,31,196,31,83,31,83,30,83,29,122,31,185,31,185,30,138,31,41,31,41,30,149,31,150,31,75,31,212,31,92,31,221,31,221,30,132,31,10,31,185,31,1,31,73,31,168,31,110,31,8,31,41,31,190,31,246,31,246,30,150,31,231,31,61,31,61,30,240,31,60,31,212,31,156,31,93,31,93,30,93,29,93,28,75,31,215,31,232,31,70,31,181,31,248,31,234,31,195,31,195,30,195,29,15,31,119,31,8,31,54,31,206,31,65,31,83,31,211,31,91,31,91,30,67,31,123,31,70,31,70,30,90,31,90,30,247,31,247,30,84,31,84,30,133,31,176,31,82,31,210,31,229,31,186,31,17,31,17,31,65,31,160,31,160,30,160,29,237,31,3,31,3,30,82,31,210,31,165,31,165,30,163,31,163,30,163,29,4,31,233,31,62,31,189,31,124,31,124,30,124,29,29,31,29,30,117,31,117,30,117,29,109,31,109,30,159,31,72,31,72,30,196,31,226,31,56,31,151,31,132,31,104,31,81,31,109,31);

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
