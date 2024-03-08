-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_982 is
end project_tb_982;

architecture project_tb_arch_982 of project_tb_982 is
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

signal scenario_input : scenario_type := (47,0,158,0,0,0,0,0,164,0,88,0,212,0,0,0,176,0,227,0,218,0,0,0,179,0,18,0,62,0,212,0,0,0,39,0,42,0,93,0,0,0,21,0,212,0,0,0,0,0,170,0,226,0,89,0,89,0,3,0,96,0,38,0,45,0,6,0,150,0,110,0,251,0,145,0,94,0,193,0,0,0,72,0,134,0,77,0,223,0,100,0,0,0,112,0,58,0,254,0,247,0,88,0,0,0,0,0,0,0,192,0,0,0,66,0,61,0,0,0,251,0,216,0,0,0,185,0,109,0,0,0,0,0,18,0,187,0,128,0,0,0,39,0,182,0,95,0,0,0,151,0,179,0,52,0,207,0,45,0,0,0,149,0,90,0,190,0,202,0,58,0,0,0,0,0,12,0,110,0,140,0,230,0,0,0,47,0,111,0,175,0,0,0,101,0,38,0,225,0,216,0,198,0,83,0,144,0,234,0,223,0,0,0,11,0,244,0,25,0,0,0,0,0,161,0,0,0,0,0,45,0,202,0,252,0,0,0,251,0,35,0,15,0,56,0,7,0,70,0,178,0,57,0,213,0,0,0,61,0,245,0,140,0,16,0,23,0,12,0,5,0,51,0,0,0,123,0,19,0,0,0,0,0,0,0,0,0,221,0,154,0,0,0,157,0,97,0,37,0,200,0,124,0,219,0,80,0,0,0,0,0,124,0,49,0,0,0,17,0,144,0,228,0,20,0,156,0,27,0,254,0,0,0,231,0,32,0,92,0,0,0,117,0,200,0,140,0,82,0,242,0,73,0,163,0,202,0,224,0,62,0,203,0,0,0,73,0,0,0,14,0,211,0,63,0,84,0,193,0,10,0,105,0,44,0,0,0,182,0,54,0,104,0,0,0,92,0,67,0,100,0,19,0,126,0,109,0,183,0,148,0,89,0,245,0,56,0,242,0,216,0,167,0,35,0,0,0,198,0,79,0,82,0,207,0,136,0,137,0,230,0,18,0,206,0,0,0,228,0,253,0,77,0,0,0,0,0,21,0,0,0,0,0,152,0,183,0,132,0,192,0,234,0,0,0,241,0,0,0,0,0,194,0,0,0,0,0,45,0,243,0,17,0,0,0,0,0,86,0,204,0,52,0,74,0,128,0,0,0,138,0,239,0,157,0,0,0,19,0,91,0,0,0,170,0,93,0,6,0,143,0,0,0,150,0,201,0,31,0,181,0,78,0,191,0,172,0,0,0,183,0,124,0,48,0,222,0,223,0,206,0,157,0,0,0,118,0,174,0,100,0,96,0,229,0,0,0,212,0,192,0,27,0,133,0,119,0,11,0,173,0,134,0,77,0,9,0,120,0,36,0,0,0,12,0,98,0,81,0,47,0,240,0,0,0,7,0,24,0,3,0,0,0,252,0,0,0,0,0,29,0,230,0,128,0,219,0,114,0,233,0,2,0,137,0,135,0,235,0,168,0,157,0,216,0,118,0,154,0,120,0,0,0,52,0,96,0,240,0,66,0,22,0,74,0,130,0,0,0,32,0,108,0,103,0,0,0,30,0,88,0,76,0,170,0,106,0,185,0,72,0,29,0,222,0,248,0,0,0,46,0,53,0,82,0,0,0,77,0,25,0,226,0,27,0,54,0,162,0,71,0,234,0,228,0,210,0,77,0,125,0,111,0,90,0,2,0,143,0,225,0,33,0,212,0,242,0,132,0,243,0,171,0,0,0,81,0,94,0,0,0,189,0,0,0,67,0,65,0,17,0,0,0,6,0,130,0,78,0,217,0,116,0,202,0,214,0,122,0,85,0,240,0,154,0,210,0,0,0,0,0,43,0);
signal scenario_full  : scenario_type := (47,31,158,31,158,30,158,29,164,31,88,31,212,31,212,30,176,31,227,31,218,31,218,30,179,31,18,31,62,31,212,31,212,30,39,31,42,31,93,31,93,30,21,31,212,31,212,30,212,29,170,31,226,31,89,31,89,31,3,31,96,31,38,31,45,31,6,31,150,31,110,31,251,31,145,31,94,31,193,31,193,30,72,31,134,31,77,31,223,31,100,31,100,30,112,31,58,31,254,31,247,31,88,31,88,30,88,29,88,28,192,31,192,30,66,31,61,31,61,30,251,31,216,31,216,30,185,31,109,31,109,30,109,29,18,31,187,31,128,31,128,30,39,31,182,31,95,31,95,30,151,31,179,31,52,31,207,31,45,31,45,30,149,31,90,31,190,31,202,31,58,31,58,30,58,29,12,31,110,31,140,31,230,31,230,30,47,31,111,31,175,31,175,30,101,31,38,31,225,31,216,31,198,31,83,31,144,31,234,31,223,31,223,30,11,31,244,31,25,31,25,30,25,29,161,31,161,30,161,29,45,31,202,31,252,31,252,30,251,31,35,31,15,31,56,31,7,31,70,31,178,31,57,31,213,31,213,30,61,31,245,31,140,31,16,31,23,31,12,31,5,31,51,31,51,30,123,31,19,31,19,30,19,29,19,28,19,27,221,31,154,31,154,30,157,31,97,31,37,31,200,31,124,31,219,31,80,31,80,30,80,29,124,31,49,31,49,30,17,31,144,31,228,31,20,31,156,31,27,31,254,31,254,30,231,31,32,31,92,31,92,30,117,31,200,31,140,31,82,31,242,31,73,31,163,31,202,31,224,31,62,31,203,31,203,30,73,31,73,30,14,31,211,31,63,31,84,31,193,31,10,31,105,31,44,31,44,30,182,31,54,31,104,31,104,30,92,31,67,31,100,31,19,31,126,31,109,31,183,31,148,31,89,31,245,31,56,31,242,31,216,31,167,31,35,31,35,30,198,31,79,31,82,31,207,31,136,31,137,31,230,31,18,31,206,31,206,30,228,31,253,31,77,31,77,30,77,29,21,31,21,30,21,29,152,31,183,31,132,31,192,31,234,31,234,30,241,31,241,30,241,29,194,31,194,30,194,29,45,31,243,31,17,31,17,30,17,29,86,31,204,31,52,31,74,31,128,31,128,30,138,31,239,31,157,31,157,30,19,31,91,31,91,30,170,31,93,31,6,31,143,31,143,30,150,31,201,31,31,31,181,31,78,31,191,31,172,31,172,30,183,31,124,31,48,31,222,31,223,31,206,31,157,31,157,30,118,31,174,31,100,31,96,31,229,31,229,30,212,31,192,31,27,31,133,31,119,31,11,31,173,31,134,31,77,31,9,31,120,31,36,31,36,30,12,31,98,31,81,31,47,31,240,31,240,30,7,31,24,31,3,31,3,30,252,31,252,30,252,29,29,31,230,31,128,31,219,31,114,31,233,31,2,31,137,31,135,31,235,31,168,31,157,31,216,31,118,31,154,31,120,31,120,30,52,31,96,31,240,31,66,31,22,31,74,31,130,31,130,30,32,31,108,31,103,31,103,30,30,31,88,31,76,31,170,31,106,31,185,31,72,31,29,31,222,31,248,31,248,30,46,31,53,31,82,31,82,30,77,31,25,31,226,31,27,31,54,31,162,31,71,31,234,31,228,31,210,31,77,31,125,31,111,31,90,31,2,31,143,31,225,31,33,31,212,31,242,31,132,31,243,31,171,31,171,30,81,31,94,31,94,30,189,31,189,30,67,31,65,31,17,31,17,30,6,31,130,31,78,31,217,31,116,31,202,31,214,31,122,31,85,31,240,31,154,31,210,31,210,30,210,29,43,31);

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
