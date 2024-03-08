-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_809 is
end project_tb_809;

architecture project_tb_arch_809 of project_tb_809 is
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

constant SCENARIO_LENGTH : integer := 390;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,194,0,23,0,0,0,0,0,136,0,8,0,136,0,185,0,7,0,160,0,113,0,0,0,81,0,49,0,253,0,211,0,74,0,0,0,0,0,71,0,0,0,145,0,162,0,108,0,164,0,134,0,0,0,169,0,240,0,61,0,68,0,132,0,141,0,0,0,183,0,59,0,0,0,216,0,253,0,191,0,63,0,19,0,35,0,0,0,0,0,0,0,169,0,22,0,140,0,74,0,88,0,189,0,107,0,135,0,90,0,142,0,189,0,194,0,208,0,44,0,118,0,57,0,19,0,211,0,138,0,153,0,239,0,0,0,152,0,0,0,201,0,0,0,0,0,0,0,221,0,149,0,0,0,164,0,36,0,170,0,31,0,91,0,252,0,0,0,123,0,136,0,145,0,153,0,0,0,213,0,0,0,0,0,186,0,0,0,99,0,50,0,135,0,130,0,242,0,77,0,1,0,5,0,17,0,145,0,222,0,174,0,53,0,131,0,60,0,43,0,202,0,246,0,43,0,86,0,48,0,247,0,20,0,0,0,158,0,25,0,95,0,37,0,0,0,141,0,99,0,255,0,51,0,0,0,114,0,89,0,0,0,164,0,65,0,0,0,223,0,128,0,185,0,243,0,79,0,180,0,117,0,12,0,162,0,97,0,154,0,32,0,211,0,145,0,0,0,226,0,0,0,211,0,156,0,189,0,100,0,0,0,187,0,249,0,70,0,110,0,54,0,211,0,37,0,181,0,210,0,135,0,0,0,171,0,116,0,150,0,0,0,162,0,208,0,73,0,231,0,10,0,53,0,187,0,0,0,119,0,218,0,0,0,136,0,16,0,0,0,170,0,0,0,144,0,61,0,77,0,43,0,34,0,0,0,134,0,110,0,230,0,0,0,1,0,0,0,167,0,211,0,154,0,11,0,0,0,0,0,229,0,24,0,52,0,14,0,253,0,179,0,137,0,101,0,179,0,0,0,0,0,13,0,0,0,159,0,60,0,105,0,0,0,90,0,0,0,108,0,0,0,48,0,20,0,134,0,131,0,28,0,58,0,0,0,214,0,231,0,225,0,0,0,255,0,0,0,115,0,84,0,155,0,59,0,0,0,201,0,14,0,4,0,245,0,0,0,168,0,61,0,245,0,29,0,0,0,48,0,78,0,12,0,189,0,112,0,144,0,106,0,0,0,97,0,0,0,249,0,79,0,8,0,200,0,0,0,140,0,111,0,70,0,244,0,92,0,86,0,8,0,200,0,189,0,0,0,72,0,207,0,0,0,86,0,0,0,99,0,12,0,0,0,120,0,247,0,160,0,0,0,185,0,89,0,51,0,117,0,160,0,0,0,0,0,141,0,162,0,223,0,35,0,0,0,125,0,251,0,217,0,241,0,27,0,194,0,74,0,3,0,84,0,168,0,49,0,118,0,6,0,228,0,0,0,106,0,221,0,120,0,143,0,120,0,205,0,204,0,226,0,114,0,173,0,58,0,4,0,0,0,130,0,233,0,127,0,135,0,0,0,233,0,66,0,0,0,57,0,0,0,1,0,169,0,179,0,162,0,107,0,149,0,0,0,212,0,0,0,74,0,84,0,84,0,147,0,0,0,96,0,52,0,155,0,136,0,0,0,252,0,86,0,42,0,0,0,0,0,0,0,165,0,238,0,152,0,131,0,0,0,175,0,182,0,0,0,112,0,16,0,175,0,185,0,131,0,0,0,243,0,0,0,96,0,243,0,232,0,56,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (0,0,194,31,23,31,23,30,23,29,136,31,8,31,136,31,185,31,7,31,160,31,113,31,113,30,81,31,49,31,253,31,211,31,74,31,74,30,74,29,71,31,71,30,145,31,162,31,108,31,164,31,134,31,134,30,169,31,240,31,61,31,68,31,132,31,141,31,141,30,183,31,59,31,59,30,216,31,253,31,191,31,63,31,19,31,35,31,35,30,35,29,35,28,169,31,22,31,140,31,74,31,88,31,189,31,107,31,135,31,90,31,142,31,189,31,194,31,208,31,44,31,118,31,57,31,19,31,211,31,138,31,153,31,239,31,239,30,152,31,152,30,201,31,201,30,201,29,201,28,221,31,149,31,149,30,164,31,36,31,170,31,31,31,91,31,252,31,252,30,123,31,136,31,145,31,153,31,153,30,213,31,213,30,213,29,186,31,186,30,99,31,50,31,135,31,130,31,242,31,77,31,1,31,5,31,17,31,145,31,222,31,174,31,53,31,131,31,60,31,43,31,202,31,246,31,43,31,86,31,48,31,247,31,20,31,20,30,158,31,25,31,95,31,37,31,37,30,141,31,99,31,255,31,51,31,51,30,114,31,89,31,89,30,164,31,65,31,65,30,223,31,128,31,185,31,243,31,79,31,180,31,117,31,12,31,162,31,97,31,154,31,32,31,211,31,145,31,145,30,226,31,226,30,211,31,156,31,189,31,100,31,100,30,187,31,249,31,70,31,110,31,54,31,211,31,37,31,181,31,210,31,135,31,135,30,171,31,116,31,150,31,150,30,162,31,208,31,73,31,231,31,10,31,53,31,187,31,187,30,119,31,218,31,218,30,136,31,16,31,16,30,170,31,170,30,144,31,61,31,77,31,43,31,34,31,34,30,134,31,110,31,230,31,230,30,1,31,1,30,167,31,211,31,154,31,11,31,11,30,11,29,229,31,24,31,52,31,14,31,253,31,179,31,137,31,101,31,179,31,179,30,179,29,13,31,13,30,159,31,60,31,105,31,105,30,90,31,90,30,108,31,108,30,48,31,20,31,134,31,131,31,28,31,58,31,58,30,214,31,231,31,225,31,225,30,255,31,255,30,115,31,84,31,155,31,59,31,59,30,201,31,14,31,4,31,245,31,245,30,168,31,61,31,245,31,29,31,29,30,48,31,78,31,12,31,189,31,112,31,144,31,106,31,106,30,97,31,97,30,249,31,79,31,8,31,200,31,200,30,140,31,111,31,70,31,244,31,92,31,86,31,8,31,200,31,189,31,189,30,72,31,207,31,207,30,86,31,86,30,99,31,12,31,12,30,120,31,247,31,160,31,160,30,185,31,89,31,51,31,117,31,160,31,160,30,160,29,141,31,162,31,223,31,35,31,35,30,125,31,251,31,217,31,241,31,27,31,194,31,74,31,3,31,84,31,168,31,49,31,118,31,6,31,228,31,228,30,106,31,221,31,120,31,143,31,120,31,205,31,204,31,226,31,114,31,173,31,58,31,4,31,4,30,130,31,233,31,127,31,135,31,135,30,233,31,66,31,66,30,57,31,57,30,1,31,169,31,179,31,162,31,107,31,149,31,149,30,212,31,212,30,74,31,84,31,84,31,147,31,147,30,96,31,52,31,155,31,136,31,136,30,252,31,86,31,42,31,42,30,42,29,42,28,165,31,238,31,152,31,131,31,131,30,175,31,182,31,182,30,112,31,16,31,175,31,185,31,131,31,131,30,243,31,243,30,96,31,243,31,232,31,56,31,56,30,56,29,56,28);

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
