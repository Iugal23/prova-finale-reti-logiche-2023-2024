-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_740 is
end project_tb_740;

architecture project_tb_arch_740 of project_tb_740 is
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

constant SCENARIO_LENGTH : integer := 452;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,167,0,216,0,70,0,0,0,151,0,135,0,61,0,236,0,29,0,121,0,0,0,242,0,244,0,0,0,223,0,105,0,0,0,10,0,139,0,0,0,81,0,0,0,150,0,72,0,174,0,0,0,140,0,218,0,0,0,64,0,0,0,145,0,39,0,99,0,37,0,234,0,136,0,167,0,0,0,125,0,246,0,239,0,248,0,128,0,147,0,68,0,213,0,0,0,6,0,16,0,77,0,128,0,19,0,0,0,183,0,136,0,142,0,104,0,86,0,0,0,240,0,0,0,156,0,161,0,126,0,0,0,221,0,6,0,0,0,128,0,104,0,17,0,24,0,251,0,153,0,62,0,80,0,25,0,223,0,0,0,91,0,0,0,50,0,196,0,82,0,237,0,0,0,242,0,14,0,3,0,225,0,246,0,0,0,0,0,206,0,0,0,69,0,167,0,108,0,9,0,0,0,52,0,118,0,178,0,129,0,119,0,0,0,100,0,128,0,161,0,0,0,0,0,139,0,193,0,226,0,146,0,24,0,0,0,15,0,48,0,94,0,0,0,55,0,156,0,0,0,232,0,202,0,183,0,85,0,77,0,0,0,234,0,242,0,0,0,219,0,136,0,245,0,0,0,220,0,147,0,0,0,95,0,148,0,207,0,212,0,241,0,206,0,246,0,0,0,13,0,236,0,71,0,53,0,25,0,91,0,0,0,149,0,221,0,20,0,0,0,51,0,236,0,165,0,0,0,49,0,39,0,0,0,0,0,53,0,0,0,133,0,0,0,169,0,176,0,75,0,127,0,29,0,0,0,214,0,45,0,0,0,0,0,46,0,0,0,94,0,94,0,149,0,183,0,50,0,98,0,0,0,243,0,23,0,247,0,120,0,52,0,197,0,190,0,29,0,231,0,144,0,0,0,49,0,75,0,208,0,92,0,82,0,30,0,113,0,173,0,175,0,27,0,85,0,0,0,13,0,101,0,17,0,0,0,215,0,0,0,203,0,48,0,97,0,95,0,0,0,130,0,70,0,0,0,11,0,0,0,198,0,60,0,225,0,50,0,20,0,252,0,0,0,107,0,167,0,150,0,140,0,169,0,104,0,0,0,148,0,162,0,0,0,117,0,0,0,214,0,0,0,233,0,157,0,13,0,87,0,61,0,114,0,22,0,0,0,122,0,225,0,199,0,136,0,193,0,71,0,0,0,0,0,233,0,61,0,0,0,45,0,58,0,29,0,248,0,224,0,210,0,0,0,237,0,0,0,228,0,178,0,37,0,124,0,136,0,144,0,149,0,43,0,107,0,2,0,94,0,177,0,112,0,186,0,0,0,72,0,105,0,0,0,0,0,0,0,80,0,17,0,152,0,197,0,0,0,0,0,19,0,246,0,28,0,251,0,145,0,0,0,146,0,195,0,11,0,165,0,122,0,143,0,157,0,3,0,0,0,0,0,84,0,227,0,227,0,3,0,242,0,220,0,0,0,139,0,192,0,41,0,135,0,52,0,212,0,175,0,63,0,0,0,218,0,0,0,228,0,0,0,3,0,0,0,219,0,17,0,0,0,102,0,180,0,21,0,0,0,102,0,1,0,205,0,196,0,66,0,236,0,118,0,4,0,105,0,0,0,63,0,102,0,38,0,247,0,3,0,0,0,39,0,0,0,0,0,56,0,121,0,216,0,124,0,183,0,115,0,121,0,112,0,169,0,23,0,93,0,232,0,196,0,0,0,0,0,154,0,93,0,1,0,5,0,143,0,54,0,89,0,138,0,35,0,0,0,0,0,16,0,222,0,10,0,223,0,103,0,225,0,0,0,185,0,0,0,250,0,0,0,254,0,119,0,242,0,91,0,205,0,124,0,0,0,118,0,19,0,46,0,222,0,158,0,1,0,70,0,80,0,79,0,227,0,74,0,0,0,0,0,99,0,246,0,0,0,144,0,154,0,0,0,0,0,55,0,0,0,187,0,16,0,30,0,176,0,36,0,0,0,46,0,160,0,177,0,139,0,187,0,4,0,221,0,183,0,51,0);
signal scenario_full  : scenario_type := (0,0,0,0,167,31,216,31,70,31,70,30,151,31,135,31,61,31,236,31,29,31,121,31,121,30,242,31,244,31,244,30,223,31,105,31,105,30,10,31,139,31,139,30,81,31,81,30,150,31,72,31,174,31,174,30,140,31,218,31,218,30,64,31,64,30,145,31,39,31,99,31,37,31,234,31,136,31,167,31,167,30,125,31,246,31,239,31,248,31,128,31,147,31,68,31,213,31,213,30,6,31,16,31,77,31,128,31,19,31,19,30,183,31,136,31,142,31,104,31,86,31,86,30,240,31,240,30,156,31,161,31,126,31,126,30,221,31,6,31,6,30,128,31,104,31,17,31,24,31,251,31,153,31,62,31,80,31,25,31,223,31,223,30,91,31,91,30,50,31,196,31,82,31,237,31,237,30,242,31,14,31,3,31,225,31,246,31,246,30,246,29,206,31,206,30,69,31,167,31,108,31,9,31,9,30,52,31,118,31,178,31,129,31,119,31,119,30,100,31,128,31,161,31,161,30,161,29,139,31,193,31,226,31,146,31,24,31,24,30,15,31,48,31,94,31,94,30,55,31,156,31,156,30,232,31,202,31,183,31,85,31,77,31,77,30,234,31,242,31,242,30,219,31,136,31,245,31,245,30,220,31,147,31,147,30,95,31,148,31,207,31,212,31,241,31,206,31,246,31,246,30,13,31,236,31,71,31,53,31,25,31,91,31,91,30,149,31,221,31,20,31,20,30,51,31,236,31,165,31,165,30,49,31,39,31,39,30,39,29,53,31,53,30,133,31,133,30,169,31,176,31,75,31,127,31,29,31,29,30,214,31,45,31,45,30,45,29,46,31,46,30,94,31,94,31,149,31,183,31,50,31,98,31,98,30,243,31,23,31,247,31,120,31,52,31,197,31,190,31,29,31,231,31,144,31,144,30,49,31,75,31,208,31,92,31,82,31,30,31,113,31,173,31,175,31,27,31,85,31,85,30,13,31,101,31,17,31,17,30,215,31,215,30,203,31,48,31,97,31,95,31,95,30,130,31,70,31,70,30,11,31,11,30,198,31,60,31,225,31,50,31,20,31,252,31,252,30,107,31,167,31,150,31,140,31,169,31,104,31,104,30,148,31,162,31,162,30,117,31,117,30,214,31,214,30,233,31,157,31,13,31,87,31,61,31,114,31,22,31,22,30,122,31,225,31,199,31,136,31,193,31,71,31,71,30,71,29,233,31,61,31,61,30,45,31,58,31,29,31,248,31,224,31,210,31,210,30,237,31,237,30,228,31,178,31,37,31,124,31,136,31,144,31,149,31,43,31,107,31,2,31,94,31,177,31,112,31,186,31,186,30,72,31,105,31,105,30,105,29,105,28,80,31,17,31,152,31,197,31,197,30,197,29,19,31,246,31,28,31,251,31,145,31,145,30,146,31,195,31,11,31,165,31,122,31,143,31,157,31,3,31,3,30,3,29,84,31,227,31,227,31,3,31,242,31,220,31,220,30,139,31,192,31,41,31,135,31,52,31,212,31,175,31,63,31,63,30,218,31,218,30,228,31,228,30,3,31,3,30,219,31,17,31,17,30,102,31,180,31,21,31,21,30,102,31,1,31,205,31,196,31,66,31,236,31,118,31,4,31,105,31,105,30,63,31,102,31,38,31,247,31,3,31,3,30,39,31,39,30,39,29,56,31,121,31,216,31,124,31,183,31,115,31,121,31,112,31,169,31,23,31,93,31,232,31,196,31,196,30,196,29,154,31,93,31,1,31,5,31,143,31,54,31,89,31,138,31,35,31,35,30,35,29,16,31,222,31,10,31,223,31,103,31,225,31,225,30,185,31,185,30,250,31,250,30,254,31,119,31,242,31,91,31,205,31,124,31,124,30,118,31,19,31,46,31,222,31,158,31,1,31,70,31,80,31,79,31,227,31,74,31,74,30,74,29,99,31,246,31,246,30,144,31,154,31,154,30,154,29,55,31,55,30,187,31,16,31,30,31,176,31,36,31,36,30,46,31,160,31,177,31,139,31,187,31,4,31,221,31,183,31,51,31);

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
