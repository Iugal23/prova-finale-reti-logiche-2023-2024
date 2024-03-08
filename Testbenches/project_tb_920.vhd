-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_920 is
end project_tb_920;

architecture project_tb_arch_920 of project_tb_920 is
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

constant SCENARIO_LENGTH : integer := 521;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,204,0,35,0,191,0,160,0,234,0,36,0,104,0,164,0,0,0,237,0,82,0,44,0,187,0,117,0,45,0,187,0,201,0,0,0,0,0,26,0,180,0,150,0,210,0,94,0,75,0,85,0,0,0,255,0,38,0,29,0,230,0,69,0,0,0,30,0,0,0,122,0,39,0,234,0,0,0,131,0,0,0,219,0,0,0,0,0,90,0,189,0,183,0,0,0,0,0,230,0,109,0,0,0,6,0,171,0,142,0,164,0,28,0,234,0,220,0,202,0,0,0,149,0,176,0,0,0,18,0,210,0,44,0,24,0,59,0,149,0,242,0,193,0,166,0,149,0,0,0,77,0,172,0,147,0,63,0,0,0,171,0,199,0,244,0,147,0,223,0,0,0,38,0,31,0,49,0,117,0,188,0,13,0,180,0,174,0,4,0,45,0,143,0,168,0,120,0,249,0,43,0,202,0,18,0,217,0,211,0,37,0,0,0,86,0,185,0,231,0,160,0,19,0,236,0,107,0,0,0,0,0,3,0,82,0,0,0,20,0,218,0,140,0,211,0,0,0,8,0,5,0,7,0,65,0,131,0,114,0,0,0,0,0,11,0,0,0,226,0,198,0,241,0,196,0,91,0,38,0,0,0,32,0,0,0,150,0,122,0,123,0,154,0,0,0,201,0,0,0,145,0,153,0,0,0,66,0,230,0,67,0,51,0,201,0,0,0,136,0,0,0,132,0,105,0,68,0,35,0,76,0,0,0,104,0,251,0,74,0,19,0,15,0,157,0,218,0,132,0,13,0,188,0,119,0,231,0,0,0,245,0,0,0,152,0,212,0,110,0,118,0,27,0,0,0,221,0,222,0,70,0,193,0,76,0,230,0,0,0,83,0,0,0,69,0,30,0,172,0,153,0,231,0,100,0,97,0,68,0,113,0,175,0,224,0,227,0,69,0,235,0,35,0,180,0,214,0,37,0,20,0,240,0,93,0,112,0,126,0,136,0,0,0,51,0,37,0,15,0,102,0,166,0,50,0,51,0,42,0,234,0,213,0,0,0,166,0,0,0,0,0,38,0,121,0,8,0,74,0,164,0,92,0,0,0,12,0,54,0,0,0,0,0,213,0,187,0,83,0,199,0,115,0,0,0,56,0,142,0,82,0,0,0,0,0,244,0,0,0,0,0,0,0,36,0,25,0,39,0,0,0,201,0,0,0,141,0,208,0,250,0,114,0,19,0,207,0,205,0,196,0,72,0,195,0,173,0,94,0,113,0,0,0,242,0,0,0,0,0,4,0,126,0,59,0,0,0,215,0,0,0,58,0,0,0,85,0,0,0,0,0,47,0,190,0,165,0,245,0,57,0,142,0,176,0,0,0,58,0,133,0,212,0,249,0,86,0,237,0,171,0,227,0,124,0,38,0,70,0,164,0,141,0,75,0,232,0,40,0,193,0,0,0,99,0,0,0,228,0,179,0,77,0,0,0,33,0,60,0,233,0,225,0,46,0,170,0,181,0,163,0,0,0,128,0,0,0,74,0,27,0,153,0,0,0,0,0,0,0,2,0,212,0,0,0,1,0,210,0,231,0,254,0,84,0,38,0,0,0,144,0,0,0,221,0,0,0,210,0,0,0,217,0,162,0,9,0,95,0,188,0,0,0,199,0,12,0,207,0,201,0,26,0,0,0,0,0,168,0,243,0,149,0,198,0,0,0,105,0,231,0,225,0,0,0,97,0,252,0,63,0,29,0,0,0,0,0,35,0,187,0,225,0,164,0,168,0,199,0,0,0,174,0,112,0,180,0,60,0,186,0,198,0,62,0,22,0,55,0,249,0,205,0,119,0,131,0,180,0,0,0,139,0,197,0,218,0,225,0,67,0,140,0,147,0,0,0,119,0,190,0,193,0,145,0,0,0,253,0,243,0,244,0,212,0,0,0,0,0,225,0,221,0,244,0,82,0,0,0,235,0,109,0,85,0,26,0,197,0,104,0,168,0,206,0,0,0,145,0,255,0,153,0,0,0,0,0,98,0,36,0,58,0,238,0,90,0,0,0,255,0,0,0,220,0,249,0,111,0,244,0,21,0,102,0,0,0,60,0,205,0,0,0,58,0,212,0,95,0,0,0,147,0,141,0,118,0,18,0,98,0,33,0,0,0,53,0,59,0,71,0,3,0,157,0,115,0,0,0,0,0,198,0,128,0,133,0,201,0,126,0,0,0,239,0,222,0,0,0,183,0,36,0,145,0,244,0,141,0,25,0,8,0,157,0,6,0,60,0,49,0,0,0,82,0,103,0,249,0,135,0,18,0,167,0,229,0,29,0,0,0,221,0,161,0,193,0,37,0);
signal scenario_full  : scenario_type := (0,0,204,31,35,31,191,31,160,31,234,31,36,31,104,31,164,31,164,30,237,31,82,31,44,31,187,31,117,31,45,31,187,31,201,31,201,30,201,29,26,31,180,31,150,31,210,31,94,31,75,31,85,31,85,30,255,31,38,31,29,31,230,31,69,31,69,30,30,31,30,30,122,31,39,31,234,31,234,30,131,31,131,30,219,31,219,30,219,29,90,31,189,31,183,31,183,30,183,29,230,31,109,31,109,30,6,31,171,31,142,31,164,31,28,31,234,31,220,31,202,31,202,30,149,31,176,31,176,30,18,31,210,31,44,31,24,31,59,31,149,31,242,31,193,31,166,31,149,31,149,30,77,31,172,31,147,31,63,31,63,30,171,31,199,31,244,31,147,31,223,31,223,30,38,31,31,31,49,31,117,31,188,31,13,31,180,31,174,31,4,31,45,31,143,31,168,31,120,31,249,31,43,31,202,31,18,31,217,31,211,31,37,31,37,30,86,31,185,31,231,31,160,31,19,31,236,31,107,31,107,30,107,29,3,31,82,31,82,30,20,31,218,31,140,31,211,31,211,30,8,31,5,31,7,31,65,31,131,31,114,31,114,30,114,29,11,31,11,30,226,31,198,31,241,31,196,31,91,31,38,31,38,30,32,31,32,30,150,31,122,31,123,31,154,31,154,30,201,31,201,30,145,31,153,31,153,30,66,31,230,31,67,31,51,31,201,31,201,30,136,31,136,30,132,31,105,31,68,31,35,31,76,31,76,30,104,31,251,31,74,31,19,31,15,31,157,31,218,31,132,31,13,31,188,31,119,31,231,31,231,30,245,31,245,30,152,31,212,31,110,31,118,31,27,31,27,30,221,31,222,31,70,31,193,31,76,31,230,31,230,30,83,31,83,30,69,31,30,31,172,31,153,31,231,31,100,31,97,31,68,31,113,31,175,31,224,31,227,31,69,31,235,31,35,31,180,31,214,31,37,31,20,31,240,31,93,31,112,31,126,31,136,31,136,30,51,31,37,31,15,31,102,31,166,31,50,31,51,31,42,31,234,31,213,31,213,30,166,31,166,30,166,29,38,31,121,31,8,31,74,31,164,31,92,31,92,30,12,31,54,31,54,30,54,29,213,31,187,31,83,31,199,31,115,31,115,30,56,31,142,31,82,31,82,30,82,29,244,31,244,30,244,29,244,28,36,31,25,31,39,31,39,30,201,31,201,30,141,31,208,31,250,31,114,31,19,31,207,31,205,31,196,31,72,31,195,31,173,31,94,31,113,31,113,30,242,31,242,30,242,29,4,31,126,31,59,31,59,30,215,31,215,30,58,31,58,30,85,31,85,30,85,29,47,31,190,31,165,31,245,31,57,31,142,31,176,31,176,30,58,31,133,31,212,31,249,31,86,31,237,31,171,31,227,31,124,31,38,31,70,31,164,31,141,31,75,31,232,31,40,31,193,31,193,30,99,31,99,30,228,31,179,31,77,31,77,30,33,31,60,31,233,31,225,31,46,31,170,31,181,31,163,31,163,30,128,31,128,30,74,31,27,31,153,31,153,30,153,29,153,28,2,31,212,31,212,30,1,31,210,31,231,31,254,31,84,31,38,31,38,30,144,31,144,30,221,31,221,30,210,31,210,30,217,31,162,31,9,31,95,31,188,31,188,30,199,31,12,31,207,31,201,31,26,31,26,30,26,29,168,31,243,31,149,31,198,31,198,30,105,31,231,31,225,31,225,30,97,31,252,31,63,31,29,31,29,30,29,29,35,31,187,31,225,31,164,31,168,31,199,31,199,30,174,31,112,31,180,31,60,31,186,31,198,31,62,31,22,31,55,31,249,31,205,31,119,31,131,31,180,31,180,30,139,31,197,31,218,31,225,31,67,31,140,31,147,31,147,30,119,31,190,31,193,31,145,31,145,30,253,31,243,31,244,31,212,31,212,30,212,29,225,31,221,31,244,31,82,31,82,30,235,31,109,31,85,31,26,31,197,31,104,31,168,31,206,31,206,30,145,31,255,31,153,31,153,30,153,29,98,31,36,31,58,31,238,31,90,31,90,30,255,31,255,30,220,31,249,31,111,31,244,31,21,31,102,31,102,30,60,31,205,31,205,30,58,31,212,31,95,31,95,30,147,31,141,31,118,31,18,31,98,31,33,31,33,30,53,31,59,31,71,31,3,31,157,31,115,31,115,30,115,29,198,31,128,31,133,31,201,31,126,31,126,30,239,31,222,31,222,30,183,31,36,31,145,31,244,31,141,31,25,31,8,31,157,31,6,31,60,31,49,31,49,30,82,31,103,31,249,31,135,31,18,31,167,31,229,31,29,31,29,30,221,31,161,31,193,31,37,31);

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
