-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_634 is
end project_tb_634;

architecture project_tb_arch_634 of project_tb_634 is
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

constant SCENARIO_LENGTH : integer := 278;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (194,0,0,0,0,0,248,0,164,0,38,0,29,0,0,0,72,0,0,0,0,0,0,0,131,0,209,0,0,0,225,0,217,0,88,0,38,0,0,0,174,0,117,0,21,0,120,0,99,0,249,0,40,0,121,0,137,0,0,0,64,0,78,0,0,0,51,0,113,0,72,0,0,0,183,0,64,0,200,0,173,0,0,0,17,0,84,0,56,0,190,0,50,0,97,0,0,0,134,0,190,0,5,0,34,0,0,0,215,0,161,0,201,0,176,0,239,0,34,0,217,0,10,0,74,0,2,0,22,0,207,0,69,0,71,0,143,0,133,0,123,0,242,0,0,0,68,0,63,0,40,0,231,0,37,0,127,0,228,0,199,0,189,0,212,0,0,0,216,0,42,0,164,0,124,0,186,0,95,0,184,0,166,0,66,0,149,0,89,0,75,0,231,0,251,0,51,0,97,0,0,0,139,0,0,0,138,0,22,0,213,0,0,0,165,0,0,0,245,0,8,0,142,0,170,0,0,0,251,0,39,0,0,0,244,0,136,0,0,0,138,0,152,0,25,0,72,0,28,0,131,0,116,0,221,0,200,0,144,0,0,0,103,0,90,0,0,0,182,0,29,0,99,0,0,0,218,0,112,0,188,0,78,0,86,0,218,0,170,0,175,0,3,0,0,0,118,0,0,0,0,0,20,0,49,0,209,0,132,0,112,0,47,0,13,0,165,0,4,0,0,0,83,0,0,0,0,0,0,0,0,0,20,0,22,0,170,0,197,0,178,0,165,0,99,0,180,0,88,0,96,0,248,0,127,0,212,0,252,0,0,0,0,0,179,0,227,0,43,0,199,0,253,0,159,0,42,0,0,0,120,0,105,0,0,0,14,0,241,0,0,0,91,0,148,0,108,0,243,0,187,0,196,0,0,0,79,0,0,0,0,0,0,0,120,0,194,0,214,0,217,0,212,0,3,0,23,0,203,0,94,0,88,0,143,0,214,0,209,0,252,0,0,0,6,0,87,0,58,0,0,0,181,0,95,0,145,0,0,0,0,0,196,0,0,0,45,0,55,0,142,0,28,0,108,0,234,0,0,0,224,0,82,0,66,0,170,0,60,0,0,0,206,0,201,0,91,0,119,0,175,0,40,0,0,0,231,0,227,0,7,0,187,0,180,0,101,0,230,0,229,0,165,0,125,0,69,0,164,0,0,0,103,0,217,0,242,0,137,0,0,0,150,0,202,0,27,0,206,0,53,0,100,0,52,0);
signal scenario_full  : scenario_type := (194,31,194,30,194,29,248,31,164,31,38,31,29,31,29,30,72,31,72,30,72,29,72,28,131,31,209,31,209,30,225,31,217,31,88,31,38,31,38,30,174,31,117,31,21,31,120,31,99,31,249,31,40,31,121,31,137,31,137,30,64,31,78,31,78,30,51,31,113,31,72,31,72,30,183,31,64,31,200,31,173,31,173,30,17,31,84,31,56,31,190,31,50,31,97,31,97,30,134,31,190,31,5,31,34,31,34,30,215,31,161,31,201,31,176,31,239,31,34,31,217,31,10,31,74,31,2,31,22,31,207,31,69,31,71,31,143,31,133,31,123,31,242,31,242,30,68,31,63,31,40,31,231,31,37,31,127,31,228,31,199,31,189,31,212,31,212,30,216,31,42,31,164,31,124,31,186,31,95,31,184,31,166,31,66,31,149,31,89,31,75,31,231,31,251,31,51,31,97,31,97,30,139,31,139,30,138,31,22,31,213,31,213,30,165,31,165,30,245,31,8,31,142,31,170,31,170,30,251,31,39,31,39,30,244,31,136,31,136,30,138,31,152,31,25,31,72,31,28,31,131,31,116,31,221,31,200,31,144,31,144,30,103,31,90,31,90,30,182,31,29,31,99,31,99,30,218,31,112,31,188,31,78,31,86,31,218,31,170,31,175,31,3,31,3,30,118,31,118,30,118,29,20,31,49,31,209,31,132,31,112,31,47,31,13,31,165,31,4,31,4,30,83,31,83,30,83,29,83,28,83,27,20,31,22,31,170,31,197,31,178,31,165,31,99,31,180,31,88,31,96,31,248,31,127,31,212,31,252,31,252,30,252,29,179,31,227,31,43,31,199,31,253,31,159,31,42,31,42,30,120,31,105,31,105,30,14,31,241,31,241,30,91,31,148,31,108,31,243,31,187,31,196,31,196,30,79,31,79,30,79,29,79,28,120,31,194,31,214,31,217,31,212,31,3,31,23,31,203,31,94,31,88,31,143,31,214,31,209,31,252,31,252,30,6,31,87,31,58,31,58,30,181,31,95,31,145,31,145,30,145,29,196,31,196,30,45,31,55,31,142,31,28,31,108,31,234,31,234,30,224,31,82,31,66,31,170,31,60,31,60,30,206,31,201,31,91,31,119,31,175,31,40,31,40,30,231,31,227,31,7,31,187,31,180,31,101,31,230,31,229,31,165,31,125,31,69,31,164,31,164,30,103,31,217,31,242,31,137,31,137,30,150,31,202,31,27,31,206,31,53,31,100,31,52,31);

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
