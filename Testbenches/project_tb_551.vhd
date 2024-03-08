-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_551 is
end project_tb_551;

architecture project_tb_arch_551 of project_tb_551 is
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

constant SCENARIO_LENGTH : integer := 615;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (4,0,175,0,172,0,128,0,215,0,226,0,111,0,1,0,106,0,150,0,21,0,130,0,34,0,57,0,240,0,80,0,35,0,205,0,245,0,236,0,97,0,0,0,144,0,77,0,56,0,235,0,91,0,141,0,136,0,0,0,182,0,158,0,34,0,240,0,150,0,173,0,195,0,93,0,226,0,81,0,10,0,157,0,166,0,0,0,77,0,40,0,139,0,207,0,118,0,0,0,89,0,108,0,64,0,93,0,56,0,113,0,245,0,0,0,0,0,45,0,235,0,117,0,210,0,139,0,163,0,45,0,189,0,193,0,236,0,10,0,82,0,126,0,221,0,0,0,138,0,103,0,0,0,145,0,114,0,93,0,47,0,164,0,218,0,0,0,0,0,217,0,61,0,33,0,130,0,55,0,81,0,30,0,0,0,96,0,124,0,110,0,249,0,166,0,66,0,115,0,159,0,0,0,19,0,111,0,134,0,143,0,191,0,44,0,131,0,119,0,165,0,0,0,18,0,210,0,207,0,118,0,0,0,0,0,116,0,0,0,0,0,222,0,42,0,141,0,125,0,182,0,0,0,30,0,122,0,54,0,0,0,7,0,212,0,73,0,85,0,152,0,160,0,48,0,42,0,184,0,240,0,0,0,125,0,250,0,136,0,0,0,68,0,0,0,0,0,116,0,164,0,0,0,137,0,109,0,77,0,198,0,2,0,200,0,142,0,0,0,228,0,228,0,20,0,98,0,240,0,0,0,118,0,228,0,77,0,0,0,29,0,157,0,96,0,79,0,206,0,48,0,206,0,5,0,0,0,208,0,118,0,154,0,18,0,113,0,0,0,186,0,218,0,92,0,0,0,113,0,181,0,9,0,37,0,81,0,0,0,173,0,0,0,41,0,233,0,204,0,153,0,0,0,0,0,203,0,0,0,171,0,15,0,226,0,176,0,143,0,0,0,180,0,223,0,224,0,64,0,142,0,215,0,61,0,128,0,111,0,213,0,55,0,61,0,0,0,140,0,202,0,94,0,15,0,145,0,0,0,187,0,173,0,175,0,74,0,0,0,34,0,24,0,211,0,133,0,86,0,223,0,45,0,59,0,137,0,15,0,156,0,70,0,131,0,131,0,136,0,223,0,5,0,215,0,130,0,0,0,60,0,14,0,132,0,54,0,98,0,146,0,88,0,146,0,0,0,15,0,3,0,58,0,0,0,0,0,130,0,62,0,221,0,247,0,0,0,94,0,0,0,237,0,15,0,0,0,199,0,3,0,223,0,120,0,172,0,153,0,215,0,254,0,31,0,179,0,0,0,124,0,0,0,6,0,0,0,0,0,0,0,148,0,80,0,251,0,233,0,40,0,188,0,0,0,54,0,87,0,0,0,0,0,30,0,148,0,246,0,35,0,90,0,82,0,115,0,67,0,57,0,171,0,29,0,0,0,92,0,65,0,139,0,0,0,153,0,25,0,0,0,143,0,0,0,0,0,89,0,86,0,0,0,0,0,0,0,0,0,144,0,28,0,44,0,88,0,28,0,0,0,0,0,0,0,0,0,199,0,221,0,237,0,202,0,189,0,204,0,76,0,0,0,182,0,246,0,44,0,133,0,105,0,28,0,0,0,58,0,18,0,17,0,13,0,132,0,44,0,192,0,61,0,35,0,91,0,71,0,101,0,98,0,94,0,156,0,17,0,0,0,0,0,226,0,48,0,181,0,0,0,0,0,0,0,58,0,103,0,205,0,97,0,24,0,0,0,198,0,253,0,0,0,51,0,251,0,196,0,0,0,138,0,49,0,239,0,142,0,73,0,0,0,110,0,0,0,24,0,253,0,205,0,213,0,85,0,157,0,180,0,146,0,65,0,243,0,101,0,43,0,237,0,52,0,137,0,30,0,156,0,104,0,10,0,215,0,28,0,91,0,180,0,0,0,253,0,53,0,226,0,239,0,173,0,235,0,1,0,0,0,157,0,103,0,165,0,218,0,166,0,136,0,162,0,23,0,0,0,127,0,101,0,225,0,0,0,75,0,118,0,31,0,123,0,108,0,168,0,136,0,10,0,137,0,223,0,38,0,23,0,239,0,0,0,0,0,185,0,3,0,80,0,146,0,53,0,0,0,76,0,195,0,99,0,0,0,188,0,183,0,237,0,130,0,0,0,178,0,0,0,139,0,250,0,64,0,0,0,33,0,40,0,30,0,9,0,42,0,242,0,108,0,47,0,0,0,36,0,52,0,0,0,235,0,126,0,169,0,31,0,255,0,159,0,0,0,210,0,126,0,62,0,238,0,0,0,101,0,11,0,157,0,244,0,124,0,27,0,185,0,193,0,0,0,146,0,0,0,169,0,144,0,6,0,48,0,130,0,0,0,165,0,219,0,23,0,82,0,90,0,6,0,31,0,0,0,228,0,199,0,158,0,40,0,126,0,144,0,103,0,21,0,169,0,101,0,80,0,6,0,17,0,243,0,0,0,189,0,234,0,144,0,105,0,0,0,86,0,21,0,243,0,148,0,0,0,78,0,145,0,208,0,0,0,212,0,204,0,226,0,116,0,0,0,29,0,27,0,158,0,135,0,95,0,245,0,167,0,178,0,255,0,22,0,160,0,8,0,0,0,61,0,236,0,201,0,26,0,139,0,0,0,19,0,123,0,18,0,0,0,181,0,62,0,188,0,34,0,108,0,83,0,224,0,227,0,0,0,0,0,227,0,114,0,20,0,90,0,239,0,212,0,75,0,147,0,70,0,14,0,187,0,96,0,42,0,107,0);
signal scenario_full  : scenario_type := (4,31,175,31,172,31,128,31,215,31,226,31,111,31,1,31,106,31,150,31,21,31,130,31,34,31,57,31,240,31,80,31,35,31,205,31,245,31,236,31,97,31,97,30,144,31,77,31,56,31,235,31,91,31,141,31,136,31,136,30,182,31,158,31,34,31,240,31,150,31,173,31,195,31,93,31,226,31,81,31,10,31,157,31,166,31,166,30,77,31,40,31,139,31,207,31,118,31,118,30,89,31,108,31,64,31,93,31,56,31,113,31,245,31,245,30,245,29,45,31,235,31,117,31,210,31,139,31,163,31,45,31,189,31,193,31,236,31,10,31,82,31,126,31,221,31,221,30,138,31,103,31,103,30,145,31,114,31,93,31,47,31,164,31,218,31,218,30,218,29,217,31,61,31,33,31,130,31,55,31,81,31,30,31,30,30,96,31,124,31,110,31,249,31,166,31,66,31,115,31,159,31,159,30,19,31,111,31,134,31,143,31,191,31,44,31,131,31,119,31,165,31,165,30,18,31,210,31,207,31,118,31,118,30,118,29,116,31,116,30,116,29,222,31,42,31,141,31,125,31,182,31,182,30,30,31,122,31,54,31,54,30,7,31,212,31,73,31,85,31,152,31,160,31,48,31,42,31,184,31,240,31,240,30,125,31,250,31,136,31,136,30,68,31,68,30,68,29,116,31,164,31,164,30,137,31,109,31,77,31,198,31,2,31,200,31,142,31,142,30,228,31,228,31,20,31,98,31,240,31,240,30,118,31,228,31,77,31,77,30,29,31,157,31,96,31,79,31,206,31,48,31,206,31,5,31,5,30,208,31,118,31,154,31,18,31,113,31,113,30,186,31,218,31,92,31,92,30,113,31,181,31,9,31,37,31,81,31,81,30,173,31,173,30,41,31,233,31,204,31,153,31,153,30,153,29,203,31,203,30,171,31,15,31,226,31,176,31,143,31,143,30,180,31,223,31,224,31,64,31,142,31,215,31,61,31,128,31,111,31,213,31,55,31,61,31,61,30,140,31,202,31,94,31,15,31,145,31,145,30,187,31,173,31,175,31,74,31,74,30,34,31,24,31,211,31,133,31,86,31,223,31,45,31,59,31,137,31,15,31,156,31,70,31,131,31,131,31,136,31,223,31,5,31,215,31,130,31,130,30,60,31,14,31,132,31,54,31,98,31,146,31,88,31,146,31,146,30,15,31,3,31,58,31,58,30,58,29,130,31,62,31,221,31,247,31,247,30,94,31,94,30,237,31,15,31,15,30,199,31,3,31,223,31,120,31,172,31,153,31,215,31,254,31,31,31,179,31,179,30,124,31,124,30,6,31,6,30,6,29,6,28,148,31,80,31,251,31,233,31,40,31,188,31,188,30,54,31,87,31,87,30,87,29,30,31,148,31,246,31,35,31,90,31,82,31,115,31,67,31,57,31,171,31,29,31,29,30,92,31,65,31,139,31,139,30,153,31,25,31,25,30,143,31,143,30,143,29,89,31,86,31,86,30,86,29,86,28,86,27,144,31,28,31,44,31,88,31,28,31,28,30,28,29,28,28,28,27,199,31,221,31,237,31,202,31,189,31,204,31,76,31,76,30,182,31,246,31,44,31,133,31,105,31,28,31,28,30,58,31,18,31,17,31,13,31,132,31,44,31,192,31,61,31,35,31,91,31,71,31,101,31,98,31,94,31,156,31,17,31,17,30,17,29,226,31,48,31,181,31,181,30,181,29,181,28,58,31,103,31,205,31,97,31,24,31,24,30,198,31,253,31,253,30,51,31,251,31,196,31,196,30,138,31,49,31,239,31,142,31,73,31,73,30,110,31,110,30,24,31,253,31,205,31,213,31,85,31,157,31,180,31,146,31,65,31,243,31,101,31,43,31,237,31,52,31,137,31,30,31,156,31,104,31,10,31,215,31,28,31,91,31,180,31,180,30,253,31,53,31,226,31,239,31,173,31,235,31,1,31,1,30,157,31,103,31,165,31,218,31,166,31,136,31,162,31,23,31,23,30,127,31,101,31,225,31,225,30,75,31,118,31,31,31,123,31,108,31,168,31,136,31,10,31,137,31,223,31,38,31,23,31,239,31,239,30,239,29,185,31,3,31,80,31,146,31,53,31,53,30,76,31,195,31,99,31,99,30,188,31,183,31,237,31,130,31,130,30,178,31,178,30,139,31,250,31,64,31,64,30,33,31,40,31,30,31,9,31,42,31,242,31,108,31,47,31,47,30,36,31,52,31,52,30,235,31,126,31,169,31,31,31,255,31,159,31,159,30,210,31,126,31,62,31,238,31,238,30,101,31,11,31,157,31,244,31,124,31,27,31,185,31,193,31,193,30,146,31,146,30,169,31,144,31,6,31,48,31,130,31,130,30,165,31,219,31,23,31,82,31,90,31,6,31,31,31,31,30,228,31,199,31,158,31,40,31,126,31,144,31,103,31,21,31,169,31,101,31,80,31,6,31,17,31,243,31,243,30,189,31,234,31,144,31,105,31,105,30,86,31,21,31,243,31,148,31,148,30,78,31,145,31,208,31,208,30,212,31,204,31,226,31,116,31,116,30,29,31,27,31,158,31,135,31,95,31,245,31,167,31,178,31,255,31,22,31,160,31,8,31,8,30,61,31,236,31,201,31,26,31,139,31,139,30,19,31,123,31,18,31,18,30,181,31,62,31,188,31,34,31,108,31,83,31,224,31,227,31,227,30,227,29,227,31,114,31,20,31,90,31,239,31,212,31,75,31,147,31,70,31,14,31,187,31,96,31,42,31,107,31);

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
