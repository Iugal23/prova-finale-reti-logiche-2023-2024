-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_969 is
end project_tb_969;

architecture project_tb_arch_969 of project_tb_969 is
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

constant SCENARIO_LENGTH : integer := 579;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (43,0,82,0,0,0,221,0,237,0,0,0,9,0,102,0,0,0,75,0,100,0,58,0,111,0,162,0,176,0,24,0,246,0,179,0,17,0,0,0,150,0,170,0,22,0,254,0,69,0,163,0,70,0,106,0,42,0,46,0,15,0,137,0,88,0,242,0,160,0,217,0,108,0,153,0,115,0,117,0,252,0,111,0,70,0,0,0,0,0,234,0,31,0,38,0,232,0,147,0,203,0,247,0,26,0,41,0,107,0,0,0,214,0,21,0,116,0,61,0,124,0,0,0,82,0,26,0,36,0,75,0,124,0,232,0,89,0,149,0,250,0,0,0,0,0,0,0,71,0,154,0,68,0,3,0,0,0,40,0,13,0,0,0,98,0,102,0,143,0,0,0,0,0,177,0,166,0,181,0,0,0,253,0,198,0,173,0,0,0,30,0,190,0,77,0,116,0,141,0,35,0,47,0,0,0,0,0,191,0,215,0,0,0,145,0,61,0,30,0,170,0,213,0,98,0,55,0,109,0,185,0,144,0,0,0,187,0,140,0,14,0,244,0,0,0,0,0,89,0,20,0,26,0,243,0,95,0,108,0,0,0,0,0,242,0,203,0,200,0,0,0,190,0,177,0,0,0,32,0,22,0,195,0,0,0,149,0,176,0,188,0,213,0,218,0,0,0,0,0,142,0,1,0,85,0,140,0,0,0,93,0,108,0,0,0,93,0,80,0,225,0,23,0,65,0,135,0,232,0,180,0,75,0,32,0,98,0,233,0,196,0,108,0,0,0,52,0,34,0,198,0,0,0,51,0,251,0,215,0,162,0,117,0,39,0,72,0,196,0,122,0,221,0,50,0,0,0,106,0,0,0,125,0,0,0,174,0,0,0,86,0,247,0,113,0,255,0,242,0,0,0,38,0,0,0,121,0,116,0,185,0,0,0,0,0,171,0,0,0,170,0,142,0,139,0,14,0,124,0,191,0,0,0,0,0,0,0,0,0,203,0,34,0,187,0,110,0,229,0,115,0,210,0,0,0,32,0,152,0,0,0,225,0,250,0,42,0,230,0,25,0,144,0,136,0,8,0,44,0,208,0,88,0,106,0,77,0,0,0,110,0,239,0,90,0,201,0,0,0,106,0,113,0,72,0,234,0,231,0,239,0,149,0,238,0,94,0,203,0,0,0,207,0,0,0,22,0,0,0,0,0,0,0,57,0,151,0,11,0,249,0,174,0,0,0,125,0,0,0,47,0,224,0,246,0,118,0,181,0,214,0,0,0,50,0,18,0,8,0,0,0,10,0,145,0,227,0,63,0,53,0,117,0,162,0,101,0,0,0,115,0,30,0,160,0,34,0,49,0,0,0,189,0,0,0,41,0,237,0,68,0,0,0,61,0,98,0,0,0,111,0,0,0,174,0,172,0,162,0,207,0,159,0,0,0,136,0,158,0,188,0,207,0,240,0,0,0,7,0,0,0,63,0,201,0,219,0,0,0,163,0,213,0,68,0,134,0,19,0,0,0,0,0,22,0,84,0,0,0,124,0,84,0,8,0,10,0,78,0,235,0,0,0,21,0,50,0,86,0,210,0,0,0,23,0,236,0,170,0,117,0,98,0,11,0,121,0,13,0,0,0,155,0,119,0,202,0,206,0,95,0,34,0,126,0,40,0,0,0,160,0,141,0,254,0,148,0,210,0,90,0,0,0,0,0,0,0,95,0,0,0,47,0,0,0,214,0,30,0,12,0,242,0,210,0,72,0,126,0,120,0,0,0,146,0,222,0,252,0,0,0,27,0,199,0,155,0,28,0,137,0,69,0,121,0,0,0,244,0,72,0,0,0,91,0,0,0,239,0,1,0,46,0,231,0,92,0,172,0,121,0,67,0,209,0,208,0,0,0,140,0,81,0,202,0,216,0,251,0,211,0,6,0,205,0,0,0,78,0,204,0,138,0,10,0,229,0,0,0,137,0,137,0,242,0,201,0,1,0,150,0,3,0,1,0,91,0,26,0,71,0,37,0,19,0,143,0,80,0,185,0,0,0,142,0,182,0,137,0,0,0,173,0,186,0,20,0,201,0,235,0,96,0,8,0,164,0,67,0,172,0,255,0,83,0,43,0,243,0,102,0,140,0,95,0,13,0,206,0,149,0,27,0,150,0,95,0,33,0,0,0,154,0,125,0,151,0,108,0,203,0,171,0,237,0,110,0,43,0,0,0,213,0,209,0,54,0,148,0,170,0,172,0,247,0,23,0,22,0,81,0,217,0,119,0,243,0,199,0,90,0,167,0,255,0,168,0,0,0,185,0,0,0,0,0,32,0,145,0,193,0,219,0,89,0,0,0,180,0,69,0,0,0,0,0,59,0,0,0,178,0,87,0,3,0,0,0,112,0,131,0,0,0,0,0,71,0,244,0,58,0,177,0,248,0,169,0,10,0,0,0,0,0,159,0,63,0,30,0,119,0,0,0,132,0,48,0,0,0,91,0,191,0,182,0,39,0,23,0,36,0,211,0,0,0,253,0,181,0,195,0,233,0,0,0,140,0,10,0,113,0,0,0,251,0,179,0,98,0,29,0,159,0,192,0,0,0,0,0,101,0,227,0,21,0,231,0);
signal scenario_full  : scenario_type := (43,31,82,31,82,30,221,31,237,31,237,30,9,31,102,31,102,30,75,31,100,31,58,31,111,31,162,31,176,31,24,31,246,31,179,31,17,31,17,30,150,31,170,31,22,31,254,31,69,31,163,31,70,31,106,31,42,31,46,31,15,31,137,31,88,31,242,31,160,31,217,31,108,31,153,31,115,31,117,31,252,31,111,31,70,31,70,30,70,29,234,31,31,31,38,31,232,31,147,31,203,31,247,31,26,31,41,31,107,31,107,30,214,31,21,31,116,31,61,31,124,31,124,30,82,31,26,31,36,31,75,31,124,31,232,31,89,31,149,31,250,31,250,30,250,29,250,28,71,31,154,31,68,31,3,31,3,30,40,31,13,31,13,30,98,31,102,31,143,31,143,30,143,29,177,31,166,31,181,31,181,30,253,31,198,31,173,31,173,30,30,31,190,31,77,31,116,31,141,31,35,31,47,31,47,30,47,29,191,31,215,31,215,30,145,31,61,31,30,31,170,31,213,31,98,31,55,31,109,31,185,31,144,31,144,30,187,31,140,31,14,31,244,31,244,30,244,29,89,31,20,31,26,31,243,31,95,31,108,31,108,30,108,29,242,31,203,31,200,31,200,30,190,31,177,31,177,30,32,31,22,31,195,31,195,30,149,31,176,31,188,31,213,31,218,31,218,30,218,29,142,31,1,31,85,31,140,31,140,30,93,31,108,31,108,30,93,31,80,31,225,31,23,31,65,31,135,31,232,31,180,31,75,31,32,31,98,31,233,31,196,31,108,31,108,30,52,31,34,31,198,31,198,30,51,31,251,31,215,31,162,31,117,31,39,31,72,31,196,31,122,31,221,31,50,31,50,30,106,31,106,30,125,31,125,30,174,31,174,30,86,31,247,31,113,31,255,31,242,31,242,30,38,31,38,30,121,31,116,31,185,31,185,30,185,29,171,31,171,30,170,31,142,31,139,31,14,31,124,31,191,31,191,30,191,29,191,28,191,27,203,31,34,31,187,31,110,31,229,31,115,31,210,31,210,30,32,31,152,31,152,30,225,31,250,31,42,31,230,31,25,31,144,31,136,31,8,31,44,31,208,31,88,31,106,31,77,31,77,30,110,31,239,31,90,31,201,31,201,30,106,31,113,31,72,31,234,31,231,31,239,31,149,31,238,31,94,31,203,31,203,30,207,31,207,30,22,31,22,30,22,29,22,28,57,31,151,31,11,31,249,31,174,31,174,30,125,31,125,30,47,31,224,31,246,31,118,31,181,31,214,31,214,30,50,31,18,31,8,31,8,30,10,31,145,31,227,31,63,31,53,31,117,31,162,31,101,31,101,30,115,31,30,31,160,31,34,31,49,31,49,30,189,31,189,30,41,31,237,31,68,31,68,30,61,31,98,31,98,30,111,31,111,30,174,31,172,31,162,31,207,31,159,31,159,30,136,31,158,31,188,31,207,31,240,31,240,30,7,31,7,30,63,31,201,31,219,31,219,30,163,31,213,31,68,31,134,31,19,31,19,30,19,29,22,31,84,31,84,30,124,31,84,31,8,31,10,31,78,31,235,31,235,30,21,31,50,31,86,31,210,31,210,30,23,31,236,31,170,31,117,31,98,31,11,31,121,31,13,31,13,30,155,31,119,31,202,31,206,31,95,31,34,31,126,31,40,31,40,30,160,31,141,31,254,31,148,31,210,31,90,31,90,30,90,29,90,28,95,31,95,30,47,31,47,30,214,31,30,31,12,31,242,31,210,31,72,31,126,31,120,31,120,30,146,31,222,31,252,31,252,30,27,31,199,31,155,31,28,31,137,31,69,31,121,31,121,30,244,31,72,31,72,30,91,31,91,30,239,31,1,31,46,31,231,31,92,31,172,31,121,31,67,31,209,31,208,31,208,30,140,31,81,31,202,31,216,31,251,31,211,31,6,31,205,31,205,30,78,31,204,31,138,31,10,31,229,31,229,30,137,31,137,31,242,31,201,31,1,31,150,31,3,31,1,31,91,31,26,31,71,31,37,31,19,31,143,31,80,31,185,31,185,30,142,31,182,31,137,31,137,30,173,31,186,31,20,31,201,31,235,31,96,31,8,31,164,31,67,31,172,31,255,31,83,31,43,31,243,31,102,31,140,31,95,31,13,31,206,31,149,31,27,31,150,31,95,31,33,31,33,30,154,31,125,31,151,31,108,31,203,31,171,31,237,31,110,31,43,31,43,30,213,31,209,31,54,31,148,31,170,31,172,31,247,31,23,31,22,31,81,31,217,31,119,31,243,31,199,31,90,31,167,31,255,31,168,31,168,30,185,31,185,30,185,29,32,31,145,31,193,31,219,31,89,31,89,30,180,31,69,31,69,30,69,29,59,31,59,30,178,31,87,31,3,31,3,30,112,31,131,31,131,30,131,29,71,31,244,31,58,31,177,31,248,31,169,31,10,31,10,30,10,29,159,31,63,31,30,31,119,31,119,30,132,31,48,31,48,30,91,31,191,31,182,31,39,31,23,31,36,31,211,31,211,30,253,31,181,31,195,31,233,31,233,30,140,31,10,31,113,31,113,30,251,31,179,31,98,31,29,31,159,31,192,31,192,30,192,29,101,31,227,31,21,31,231,31);

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
