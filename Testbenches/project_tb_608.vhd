-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_608 is
end project_tb_608;

architecture project_tb_arch_608 of project_tb_608 is
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

constant SCENARIO_LENGTH : integer := 423;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (65,0,0,0,79,0,242,0,191,0,207,0,0,0,186,0,90,0,44,0,190,0,157,0,0,0,0,0,0,0,154,0,95,0,100,0,40,0,220,0,222,0,237,0,0,0,39,0,46,0,239,0,128,0,152,0,8,0,69,0,142,0,240,0,241,0,230,0,0,0,84,0,135,0,150,0,53,0,109,0,178,0,0,0,49,0,3,0,111,0,105,0,130,0,0,0,72,0,210,0,70,0,230,0,158,0,61,0,0,0,34,0,0,0,205,0,26,0,132,0,174,0,0,0,252,0,201,0,0,0,6,0,225,0,57,0,0,0,0,0,142,0,163,0,0,0,0,0,0,0,225,0,228,0,154,0,114,0,241,0,109,0,245,0,144,0,83,0,42,0,221,0,0,0,0,0,74,0,8,0,223,0,0,0,69,0,110,0,166,0,181,0,217,0,10,0,120,0,249,0,122,0,201,0,148,0,81,0,75,0,182,0,12,0,190,0,61,0,0,0,117,0,121,0,245,0,17,0,0,0,123,0,234,0,112,0,0,0,52,0,206,0,23,0,77,0,0,0,195,0,149,0,66,0,183,0,65,0,219,0,84,0,154,0,247,0,24,0,0,0,0,0,0,0,94,0,16,0,171,0,240,0,90,0,218,0,5,0,171,0,244,0,26,0,179,0,44,0,104,0,0,0,195,0,211,0,206,0,40,0,153,0,83,0,110,0,0,0,223,0,0,0,53,0,0,0,187,0,89,0,0,0,119,0,0,0,237,0,149,0,8,0,173,0,137,0,64,0,115,0,147,0,214,0,0,0,180,0,0,0,191,0,239,0,238,0,0,0,0,0,203,0,198,0,0,0,50,0,141,0,0,0,231,0,46,0,181,0,50,0,31,0,58,0,27,0,13,0,18,0,67,0,5,0,190,0,0,0,64,0,41,0,240,0,108,0,224,0,0,0,145,0,0,0,159,0,200,0,66,0,122,0,104,0,144,0,249,0,67,0,91,0,170,0,249,0,70,0,35,0,164,0,186,0,91,0,0,0,120,0,4,0,199,0,147,0,194,0,244,0,252,0,84,0,126,0,230,0,0,0,0,0,216,0,122,0,180,0,189,0,219,0,170,0,225,0,198,0,215,0,158,0,145,0,221,0,98,0,0,0,60,0,189,0,16,0,52,0,122,0,181,0,21,0,5,0,0,0,213,0,28,0,40,0,33,0,99,0,0,0,221,0,188,0,70,0,135,0,132,0,17,0,33,0,16,0,97,0,53,0,0,0,194,0,0,0,136,0,213,0,0,0,207,0,220,0,136,0,89,0,34,0,0,0,24,0,160,0,50,0,163,0,28,0,223,0,225,0,70,0,206,0,165,0,67,0,0,0,0,0,223,0,179,0,66,0,131,0,94,0,125,0,0,0,185,0,118,0,225,0,0,0,9,0,204,0,174,0,16,0,240,0,0,0,208,0,196,0,33,0,69,0,226,0,250,0,148,0,87,0,175,0,180,0,19,0,148,0,232,0,157,0,235,0,14,0,10,0,165,0,8,0,140,0,90,0,50,0,75,0,0,0,0,0,0,0,0,0,227,0,199,0,0,0,98,0,0,0,188,0,73,0,103,0,0,0,182,0,0,0,130,0,177,0,249,0,72,0,104,0,168,0,244,0,9,0,0,0,193,0,16,0,47,0,169,0,172,0,0,0,239,0,157,0,87,0,15,0,23,0,0,0,252,0,69,0,203,0,67,0,76,0,0,0,66,0,148,0,0,0,210,0,83,0,102,0,211,0,0,0,164,0,0,0,0,0,3,0,177,0,7,0,103,0,159,0,180,0,16,0,0,0,206,0,108,0,32,0,19,0,62,0,191,0,0,0,247,0,113,0,26,0,37,0,172,0,0,0,121,0,93,0,197,0,156,0);
signal scenario_full  : scenario_type := (65,31,65,30,79,31,242,31,191,31,207,31,207,30,186,31,90,31,44,31,190,31,157,31,157,30,157,29,157,28,154,31,95,31,100,31,40,31,220,31,222,31,237,31,237,30,39,31,46,31,239,31,128,31,152,31,8,31,69,31,142,31,240,31,241,31,230,31,230,30,84,31,135,31,150,31,53,31,109,31,178,31,178,30,49,31,3,31,111,31,105,31,130,31,130,30,72,31,210,31,70,31,230,31,158,31,61,31,61,30,34,31,34,30,205,31,26,31,132,31,174,31,174,30,252,31,201,31,201,30,6,31,225,31,57,31,57,30,57,29,142,31,163,31,163,30,163,29,163,28,225,31,228,31,154,31,114,31,241,31,109,31,245,31,144,31,83,31,42,31,221,31,221,30,221,29,74,31,8,31,223,31,223,30,69,31,110,31,166,31,181,31,217,31,10,31,120,31,249,31,122,31,201,31,148,31,81,31,75,31,182,31,12,31,190,31,61,31,61,30,117,31,121,31,245,31,17,31,17,30,123,31,234,31,112,31,112,30,52,31,206,31,23,31,77,31,77,30,195,31,149,31,66,31,183,31,65,31,219,31,84,31,154,31,247,31,24,31,24,30,24,29,24,28,94,31,16,31,171,31,240,31,90,31,218,31,5,31,171,31,244,31,26,31,179,31,44,31,104,31,104,30,195,31,211,31,206,31,40,31,153,31,83,31,110,31,110,30,223,31,223,30,53,31,53,30,187,31,89,31,89,30,119,31,119,30,237,31,149,31,8,31,173,31,137,31,64,31,115,31,147,31,214,31,214,30,180,31,180,30,191,31,239,31,238,31,238,30,238,29,203,31,198,31,198,30,50,31,141,31,141,30,231,31,46,31,181,31,50,31,31,31,58,31,27,31,13,31,18,31,67,31,5,31,190,31,190,30,64,31,41,31,240,31,108,31,224,31,224,30,145,31,145,30,159,31,200,31,66,31,122,31,104,31,144,31,249,31,67,31,91,31,170,31,249,31,70,31,35,31,164,31,186,31,91,31,91,30,120,31,4,31,199,31,147,31,194,31,244,31,252,31,84,31,126,31,230,31,230,30,230,29,216,31,122,31,180,31,189,31,219,31,170,31,225,31,198,31,215,31,158,31,145,31,221,31,98,31,98,30,60,31,189,31,16,31,52,31,122,31,181,31,21,31,5,31,5,30,213,31,28,31,40,31,33,31,99,31,99,30,221,31,188,31,70,31,135,31,132,31,17,31,33,31,16,31,97,31,53,31,53,30,194,31,194,30,136,31,213,31,213,30,207,31,220,31,136,31,89,31,34,31,34,30,24,31,160,31,50,31,163,31,28,31,223,31,225,31,70,31,206,31,165,31,67,31,67,30,67,29,223,31,179,31,66,31,131,31,94,31,125,31,125,30,185,31,118,31,225,31,225,30,9,31,204,31,174,31,16,31,240,31,240,30,208,31,196,31,33,31,69,31,226,31,250,31,148,31,87,31,175,31,180,31,19,31,148,31,232,31,157,31,235,31,14,31,10,31,165,31,8,31,140,31,90,31,50,31,75,31,75,30,75,29,75,28,75,27,227,31,199,31,199,30,98,31,98,30,188,31,73,31,103,31,103,30,182,31,182,30,130,31,177,31,249,31,72,31,104,31,168,31,244,31,9,31,9,30,193,31,16,31,47,31,169,31,172,31,172,30,239,31,157,31,87,31,15,31,23,31,23,30,252,31,69,31,203,31,67,31,76,31,76,30,66,31,148,31,148,30,210,31,83,31,102,31,211,31,211,30,164,31,164,30,164,29,3,31,177,31,7,31,103,31,159,31,180,31,16,31,16,30,206,31,108,31,32,31,19,31,62,31,191,31,191,30,247,31,113,31,26,31,37,31,172,31,172,30,121,31,93,31,197,31,156,31);

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
