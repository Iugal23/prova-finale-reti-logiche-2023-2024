-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_621 is
end project_tb_621;

architecture project_tb_arch_621 of project_tb_621 is
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

constant SCENARIO_LENGTH : integer := 360;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (40,0,7,0,203,0,25,0,40,0,204,0,17,0,155,0,140,0,153,0,4,0,64,0,243,0,118,0,0,0,0,0,105,0,128,0,254,0,189,0,36,0,188,0,42,0,227,0,205,0,179,0,0,0,0,0,0,0,27,0,0,0,145,0,202,0,62,0,61,0,0,0,156,0,0,0,50,0,169,0,136,0,0,0,114,0,0,0,96,0,37,0,69,0,127,0,163,0,24,0,15,0,201,0,175,0,88,0,132,0,173,0,245,0,3,0,141,0,251,0,34,0,0,0,104,0,242,0,159,0,81,0,51,0,193,0,230,0,186,0,193,0,166,0,0,0,116,0,0,0,37,0,237,0,46,0,108,0,0,0,29,0,77,0,58,0,101,0,125,0,133,0,69,0,95,0,169,0,40,0,0,0,244,0,216,0,254,0,202,0,203,0,181,0,130,0,75,0,4,0,48,0,0,0,237,0,175,0,0,0,12,0,0,0,202,0,2,0,194,0,131,0,98,0,48,0,34,0,228,0,87,0,208,0,35,0,57,0,242,0,62,0,0,0,103,0,0,0,240,0,172,0,157,0,246,0,0,0,1,0,238,0,0,0,135,0,228,0,217,0,56,0,2,0,0,0,239,0,102,0,229,0,180,0,152,0,232,0,20,0,103,0,138,0,101,0,0,0,0,0,155,0,0,0,25,0,1,0,177,0,50,0,191,0,22,0,232,0,63,0,65,0,92,0,175,0,12,0,169,0,130,0,243,0,23,0,97,0,0,0,42,0,133,0,103,0,62,0,50,0,174,0,63,0,2,0,241,0,99,0,0,0,107,0,0,0,69,0,0,0,196,0,193,0,0,0,187,0,200,0,121,0,188,0,172,0,20,0,0,0,204,0,104,0,188,0,219,0,46,0,211,0,172,0,156,0,117,0,93,0,49,0,62,0,245,0,0,0,208,0,98,0,138,0,251,0,190,0,171,0,0,0,0,0,36,0,203,0,27,0,169,0,160,0,0,0,3,0,52,0,0,0,51,0,96,0,106,0,100,0,0,0,104,0,0,0,0,0,71,0,62,0,193,0,64,0,35,0,0,0,116,0,80,0,0,0,137,0,62,0,31,0,0,0,0,0,0,0,18,0,78,0,77,0,7,0,36,0,121,0,74,0,229,0,223,0,173,0,174,0,155,0,182,0,122,0,37,0,252,0,50,0,0,0,0,0,137,0,0,0,60,0,83,0,0,0,140,0,34,0,224,0,0,0,206,0,129,0,181,0,0,0,150,0,178,0,0,0,75,0,181,0,151,0,206,0,194,0,193,0,104,0,79,0,180,0,40,0,163,0,45,0,42,0,177,0,137,0,213,0,163,0,20,0,0,0,56,0,33,0,61,0,38,0,236,0,217,0,255,0,222,0,249,0,158,0,201,0,57,0,215,0,217,0,0,0,31,0,17,0,145,0,33,0,63,0,151,0,237,0,203,0,148,0,32,0,198,0,45,0,215,0,219,0,0,0,212,0,91,0,0,0,20,0,38,0,85,0,166,0,89,0,105,0,68,0,176,0,98,0,143,0,192,0,0,0,241,0,72,0,134,0,8,0,0,0,0,0,65,0,39,0,213,0,0,0,62,0,55,0);
signal scenario_full  : scenario_type := (40,31,7,31,203,31,25,31,40,31,204,31,17,31,155,31,140,31,153,31,4,31,64,31,243,31,118,31,118,30,118,29,105,31,128,31,254,31,189,31,36,31,188,31,42,31,227,31,205,31,179,31,179,30,179,29,179,28,27,31,27,30,145,31,202,31,62,31,61,31,61,30,156,31,156,30,50,31,169,31,136,31,136,30,114,31,114,30,96,31,37,31,69,31,127,31,163,31,24,31,15,31,201,31,175,31,88,31,132,31,173,31,245,31,3,31,141,31,251,31,34,31,34,30,104,31,242,31,159,31,81,31,51,31,193,31,230,31,186,31,193,31,166,31,166,30,116,31,116,30,37,31,237,31,46,31,108,31,108,30,29,31,77,31,58,31,101,31,125,31,133,31,69,31,95,31,169,31,40,31,40,30,244,31,216,31,254,31,202,31,203,31,181,31,130,31,75,31,4,31,48,31,48,30,237,31,175,31,175,30,12,31,12,30,202,31,2,31,194,31,131,31,98,31,48,31,34,31,228,31,87,31,208,31,35,31,57,31,242,31,62,31,62,30,103,31,103,30,240,31,172,31,157,31,246,31,246,30,1,31,238,31,238,30,135,31,228,31,217,31,56,31,2,31,2,30,239,31,102,31,229,31,180,31,152,31,232,31,20,31,103,31,138,31,101,31,101,30,101,29,155,31,155,30,25,31,1,31,177,31,50,31,191,31,22,31,232,31,63,31,65,31,92,31,175,31,12,31,169,31,130,31,243,31,23,31,97,31,97,30,42,31,133,31,103,31,62,31,50,31,174,31,63,31,2,31,241,31,99,31,99,30,107,31,107,30,69,31,69,30,196,31,193,31,193,30,187,31,200,31,121,31,188,31,172,31,20,31,20,30,204,31,104,31,188,31,219,31,46,31,211,31,172,31,156,31,117,31,93,31,49,31,62,31,245,31,245,30,208,31,98,31,138,31,251,31,190,31,171,31,171,30,171,29,36,31,203,31,27,31,169,31,160,31,160,30,3,31,52,31,52,30,51,31,96,31,106,31,100,31,100,30,104,31,104,30,104,29,71,31,62,31,193,31,64,31,35,31,35,30,116,31,80,31,80,30,137,31,62,31,31,31,31,30,31,29,31,28,18,31,78,31,77,31,7,31,36,31,121,31,74,31,229,31,223,31,173,31,174,31,155,31,182,31,122,31,37,31,252,31,50,31,50,30,50,29,137,31,137,30,60,31,83,31,83,30,140,31,34,31,224,31,224,30,206,31,129,31,181,31,181,30,150,31,178,31,178,30,75,31,181,31,151,31,206,31,194,31,193,31,104,31,79,31,180,31,40,31,163,31,45,31,42,31,177,31,137,31,213,31,163,31,20,31,20,30,56,31,33,31,61,31,38,31,236,31,217,31,255,31,222,31,249,31,158,31,201,31,57,31,215,31,217,31,217,30,31,31,17,31,145,31,33,31,63,31,151,31,237,31,203,31,148,31,32,31,198,31,45,31,215,31,219,31,219,30,212,31,91,31,91,30,20,31,38,31,85,31,166,31,89,31,105,31,68,31,176,31,98,31,143,31,192,31,192,30,241,31,72,31,134,31,8,31,8,30,8,29,65,31,39,31,213,31,213,30,62,31,55,31);

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
