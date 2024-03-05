-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

signal scenario_input : scenario_type := (0,0,202,0,76,0,74,0,237,0,104,0,74,0,0,0,0,0,218,0,55,0,241,0,0,0,0,0,45,0,105,0,63,0,45,0,45,0,0,0,51,0,0,0,110,0,0,0,208,0,134,0,43,0,68,0,175,0,136,0,12,0,251,0,11,0,58,0,245,0,13,0,130,0,45,0,171,0,74,0,121,0,63,0,60,0,145,0,122,0,61,0,251,0,149,0,114,0,206,0,204,0,46,0,134,0,229,0,199,0,154,0,0,0,76,0,215,0,0,0,74,0,0,0,75,0,82,0,22,0,42,0,9,0,188,0,0,0,223,0,154,0,156,0,0,0,41,0,34,0,209,0,89,0,233,0,202,0,59,0,251,0,68,0,170,0,78,0,52,0,33,0,75,0,88,0,0,0,191,0,61,0,172,0,53,0,187,0,119,0,0,0,255,0,0,0,0,0,66,0,5,0,195,0,215,0,90,0,223,0,0,0,0,0,216,0,234,0,228,0,208,0,0,0,74,0,98,0,0,0,179,0,93,0,80,0,219,0,0,0,0,0,0,0,171,0,31,0,18,0,189,0,0,0,114,0,32,0,0,0,37,0,253,0,223,0,232,0,62,0,133,0,69,0,217,0,108,0,78,0,199,0,73,0,66,0,186,0,243,0,108,0,115,0,0,0,0,0,152,0,179,0,0,0,0,0,100,0,0,0,77,0,31,0,79,0,0,0,180,0,134,0,88,0,142,0,79,0,106,0,155,0,85,0,8,0,146,0,40,0,247,0,248,0,150,0,161,0,53,0,98,0,79,0,0,0,68,0,0,0,119,0,137,0,240,0,58,0,170,0,220,0,205,0,0,0,148,0,88,0,114,0,3,0,40,0,162,0,17,0,56,0,108,0,134,0,0,0,228,0,132,0,160,0,9,0,125,0,35,0,138,0,132,0,0,0,39,0,230,0,134,0,234,0,149,0,0,0,153,0,0,0,76,0,52,0,41,0,38,0,0,0,81,0,75,0,202,0,242,0,128,0,44,0,207,0,16,0,0,0,236,0,0,0,0,0,0,0,0,0,104,0,66,0,70,0,175,0,86,0,78,0,233,0,144,0,124,0,62,0,0,0,0,0,0,0,52,0,0,0,113,0,60,0,39,0,0,0,11,0,103,0,137,0,17,0,0,0,0,0,0,0,246,0,0,0,140,0,0,0,130,0,80,0,0,0,151,0,127,0,89,0,120,0,94,0,0,0,220,0,0,0,21,0,25,0,72,0,149,0,77,0,0,0,209,0,171,0,237,0,89,0,173,0,204,0,130,0,109,0,0,0,84,0,75,0,50,0,207,0,150,0,96,0,15,0,33,0,0,0,115,0,146,0,0,0,125,0,0,0,0,0,58,0,41,0,233,0,35,0,204,0,143,0,154,0,179,0,43,0,234,0,214,0,160,0,0,0,147,0,201,0,201,0,202,0,0,0,41,0,96,0,185,0,221,0,148,0,243,0,0,0,143,0,218,0,235,0,38,0,241,0,0,0,0,0,131,0,0,0,183,0,153,0,130,0,145,0,84,0,140,0,20,0,148,0,0,0,0,0,22,0,0,0,0,0,134,0,68,0,116,0,20,0,111,0,35,0,82,0,127,0,228,0,27,0,189,0,0,0,170,0,160,0,161,0,96,0,229,0,241,0,115,0,203,0,37,0,0,0,147,0,46,0,198,0,78,0,127,0,227,0,0,0,59,0,0,0,64,0,0,0,12,0,184,0,98,0,123,0,108,0,0,0,205,0,116,0,139,0,132,0,236,0,69,0,167,0,0,0,0,0,46,0,229,0,230,0,12,0,16,0,120,0,11,0,194,0,144,0,225,0,123,0,170,0,0,0,65,0,172,0,0,0,102,0,79,0,197,0,235,0,178,0,110,0,95,0,0,0,177,0,0,0,0,0,255,0,195,0,241,0,7,0,0,0,227,0,29,0,26,0,231,0,250,0,116,0,171,0,129,0,34,0,0,0,53,0,7,0,0,0,107,0,230,0,42,0,60,0,220,0,61,0,35,0,0,0,11,0,246,0,53,0,0,0,35,0,0,0,202,0,0,0,149,0,26,0,208,0,202,0,0,0,251,0,1,0,241,0,99,0,199,0,72,0,0,0,127,0,44,0,8,0,155,0,224,0,160,0,172,0,0,0,0,0,170,0,217,0,0,0,0,0,138,0,225,0,0,0,158,0,72,0,87,0,69,0,219,0,201,0,100,0,250,0,82,0,182,0,0,0,133,0,0,0,193,0,78,0,75,0,148,0,105,0,60,0,59,0,101,0,179,0,52,0,10,0,23,0,11,0,90,0,24,0,246,0,243,0,67,0,86,0,11,0,145,0,70,0,125,0,144,0,220,0,0,0,217,0,0,0,60,0,251,0,67,0,82,0,0,0,78,0,241,0,0,0,0,0,64,0,181,0,221,0,19,0,133,0,148,0,253,0);
signal scenario_full  : scenario_type := (0,0,202,31,76,31,74,31,237,31,104,31,74,31,74,30,74,29,218,31,55,31,241,31,241,30,241,29,45,31,105,31,63,31,45,31,45,31,45,30,51,31,51,30,110,31,110,30,208,31,134,31,43,31,68,31,175,31,136,31,12,31,251,31,11,31,58,31,245,31,13,31,130,31,45,31,171,31,74,31,121,31,63,31,60,31,145,31,122,31,61,31,251,31,149,31,114,31,206,31,204,31,46,31,134,31,229,31,199,31,154,31,154,30,76,31,215,31,215,30,74,31,74,30,75,31,82,31,22,31,42,31,9,31,188,31,188,30,223,31,154,31,156,31,156,30,41,31,34,31,209,31,89,31,233,31,202,31,59,31,251,31,68,31,170,31,78,31,52,31,33,31,75,31,88,31,88,30,191,31,61,31,172,31,53,31,187,31,119,31,119,30,255,31,255,30,255,29,66,31,5,31,195,31,215,31,90,31,223,31,223,30,223,29,216,31,234,31,228,31,208,31,208,30,74,31,98,31,98,30,179,31,93,31,80,31,219,31,219,30,219,29,219,28,171,31,31,31,18,31,189,31,189,30,114,31,32,31,32,30,37,31,253,31,223,31,232,31,62,31,133,31,69,31,217,31,108,31,78,31,199,31,73,31,66,31,186,31,243,31,108,31,115,31,115,30,115,29,152,31,179,31,179,30,179,29,100,31,100,30,77,31,31,31,79,31,79,30,180,31,134,31,88,31,142,31,79,31,106,31,155,31,85,31,8,31,146,31,40,31,247,31,248,31,150,31,161,31,53,31,98,31,79,31,79,30,68,31,68,30,119,31,137,31,240,31,58,31,170,31,220,31,205,31,205,30,148,31,88,31,114,31,3,31,40,31,162,31,17,31,56,31,108,31,134,31,134,30,228,31,132,31,160,31,9,31,125,31,35,31,138,31,132,31,132,30,39,31,230,31,134,31,234,31,149,31,149,30,153,31,153,30,76,31,52,31,41,31,38,31,38,30,81,31,75,31,202,31,242,31,128,31,44,31,207,31,16,31,16,30,236,31,236,30,236,29,236,28,236,27,104,31,66,31,70,31,175,31,86,31,78,31,233,31,144,31,124,31,62,31,62,30,62,29,62,28,52,31,52,30,113,31,60,31,39,31,39,30,11,31,103,31,137,31,17,31,17,30,17,29,17,28,246,31,246,30,140,31,140,30,130,31,80,31,80,30,151,31,127,31,89,31,120,31,94,31,94,30,220,31,220,30,21,31,25,31,72,31,149,31,77,31,77,30,209,31,171,31,237,31,89,31,173,31,204,31,130,31,109,31,109,30,84,31,75,31,50,31,207,31,150,31,96,31,15,31,33,31,33,30,115,31,146,31,146,30,125,31,125,30,125,29,58,31,41,31,233,31,35,31,204,31,143,31,154,31,179,31,43,31,234,31,214,31,160,31,160,30,147,31,201,31,201,31,202,31,202,30,41,31,96,31,185,31,221,31,148,31,243,31,243,30,143,31,218,31,235,31,38,31,241,31,241,30,241,29,131,31,131,30,183,31,153,31,130,31,145,31,84,31,140,31,20,31,148,31,148,30,148,29,22,31,22,30,22,29,134,31,68,31,116,31,20,31,111,31,35,31,82,31,127,31,228,31,27,31,189,31,189,30,170,31,160,31,161,31,96,31,229,31,241,31,115,31,203,31,37,31,37,30,147,31,46,31,198,31,78,31,127,31,227,31,227,30,59,31,59,30,64,31,64,30,12,31,184,31,98,31,123,31,108,31,108,30,205,31,116,31,139,31,132,31,236,31,69,31,167,31,167,30,167,29,46,31,229,31,230,31,12,31,16,31,120,31,11,31,194,31,144,31,225,31,123,31,170,31,170,30,65,31,172,31,172,30,102,31,79,31,197,31,235,31,178,31,110,31,95,31,95,30,177,31,177,30,177,29,255,31,195,31,241,31,7,31,7,30,227,31,29,31,26,31,231,31,250,31,116,31,171,31,129,31,34,31,34,30,53,31,7,31,7,30,107,31,230,31,42,31,60,31,220,31,61,31,35,31,35,30,11,31,246,31,53,31,53,30,35,31,35,30,202,31,202,30,149,31,26,31,208,31,202,31,202,30,251,31,1,31,241,31,99,31,199,31,72,31,72,30,127,31,44,31,8,31,155,31,224,31,160,31,172,31,172,30,172,29,170,31,217,31,217,30,217,29,138,31,225,31,225,30,158,31,72,31,87,31,69,31,219,31,201,31,100,31,250,31,82,31,182,31,182,30,133,31,133,30,193,31,78,31,75,31,148,31,105,31,60,31,59,31,101,31,179,31,52,31,10,31,23,31,11,31,90,31,24,31,246,31,243,31,67,31,86,31,11,31,145,31,70,31,125,31,144,31,220,31,220,30,217,31,217,30,60,31,251,31,67,31,82,31,82,30,78,31,241,31,241,30,241,29,64,31,181,31,221,31,19,31,133,31,148,31,253,31);

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
